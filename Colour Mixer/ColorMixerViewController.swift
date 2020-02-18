//
//  ViewController.swift
//  Colour Mixer
//
//  Created by Irina Kopchenova on 01.02.2020.
//  Copyright © 2020 Mikhail Scherbina. All rights reserved.
//

import UIKit

protocol ColorMixerViewControllerDelegate {
    func updateColor(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ alpha: CGFloat)
}

class ColorMixerViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var colourView: UIView!
    
    @IBOutlet weak var redValueLabel: UILabel!
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var redTextField: UITextField!
    
    @IBOutlet weak var greenValueLabel: UILabel!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var greenTextField: UITextField!
    
    @IBOutlet weak var blueValueLabel: UILabel!
    @IBOutlet weak var blueSlider: UISlider!
    @IBOutlet weak var blueTextField: UITextField!
    
    @IBOutlet var toolbar: UIToolbar!
    
    var color: UIColor!
    var delegate: ColorMixerViewControllerDelegate!
    
    var alphaValue: CGFloat =  0
    
    let redBoardValue: CGFloat = 0
    let greenBoardValue: CGFloat = 0.27
    let blueBoardValue: CGFloat = 0.56
    
    var redOldValue: CGFloat = 0
    var greenOldValue: CGFloat = 0
    var blueOldValue: CGFloat = 0
    
    var redCurrentValue: CGFloat = 0 //0.76
    var greenCurrentValue: CGFloat = 0 //0.26
    var blueCurrentValue: CGFloat = 0 //0.49
    
    enum RGB {
        case red
        case green
        case blue
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colourView.layer.cornerRadius = 10
        
        // Read RGB cololor from 'color'
        color.getRed(&redCurrentValue, green: &greenCurrentValue, blue: &blueCurrentValue, alpha: &alphaValue)
        
        updateDefaults()
        updateValue(for: redValueLabel, greenValueLabel, blueValueLabel)
        updateValue(for: redSlider, greenSlider, blueSlider)
        updateValue(for: redTextField, greenTextField, blueTextField)
        
        setColor()
        
        redTextField.delegate = self
        greenTextField.delegate = self
        blueTextField.delegate = self
        
    }

    @IBAction func redSliderAction(_ sender: UISlider) {
        redCurrentValue = CGFloat(sender.value)
        updateValue(for: redSlider)
        updateValue(for: redValueLabel)
        updateValue(for: redTextField)
        setColor()
    }
    
    @IBAction func greenSliderAction(_ sender: UISlider) {
        greenCurrentValue = CGFloat(sender.value)
        updateValue(for: greenSlider)
        updateValue(for: greenValueLabel)
        updateValue(for: greenTextField)
        setColor()
    }
    
    @IBAction func blueSliderAction(_ sender: UISlider) {
        blueCurrentValue = CGFloat(sender.value)
        updateValue(for: blueSlider)
        updateValue(for: blueValueLabel)
        updateValue(for: blueTextField)
        setColor()
    }
    
    @IBAction func didClickDoneButton(_ sender: UIBarButtonItem) {
        view.endEditing(true)
    }
    
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        delegate.updateColor(redCurrentValue, greenCurrentValue, blueCurrentValue, alphaValue)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("Begin editing text field")
        redOldValue = redCurrentValue
        greenOldValue = greenCurrentValue
        blueOldValue = blueCurrentValue
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        var currentValue: CGFloat
        
        if let dbl = Double(textField.text!), dbl >= 0 && dbl <= 1 {
            currentValue = CGFloat(dbl)
            
            switch textField.tag {
            case 0:
                redCurrentValue = currentValue
                updateValue(for: redSlider)
                updateValue(for: redValueLabel)
            case 1:
                greenCurrentValue = currentValue
                updateValue(for: greenSlider)
                updateValue(for: greenValueLabel)
            case 2:
                blueCurrentValue = currentValue
                updateValue(for: blueSlider)
                updateValue(for: blueValueLabel)
            default: break
            }
            
            updateValue(for: textField)
            setColor()
            
        } else {
            showAlert(title: "Warning!", message: "Value of colour must from 0.0 to 1.0. Please enter correct value.")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func setColor() {
        colourView.backgroundColor = UIColor(red: redCurrentValue, green: greenCurrentValue, blue: blueCurrentValue, alpha: alphaValue)
    }
    
    func string(value: CGFloat) -> String {
        return String(format: "%.2f",value)
    }
    
    
    func updateDefaults() {
        view.backgroundColor = UIColor(red: redBoardValue, green: greenBoardValue, blue: blueBoardValue, alpha: alphaValue)
        
        redSlider.minimumTrackTintColor = UIColor.red
        redTextField.keyboardType = UIKeyboardType.decimalPad
        redTextField.inputAccessoryView = toolbar
        redTextField.textAlignment = .right
        
        greenSlider.minimumTrackTintColor = UIColor.green
        greenTextField.keyboardType = UIKeyboardType.decimalPad
        greenTextField.inputAccessoryView = toolbar
        greenTextField.textAlignment = .right
        
        blueTextField.keyboardType = UIKeyboardType.decimalPad
        blueTextField.inputAccessoryView = toolbar
        blueTextField.textAlignment = .right
    }
    
    func updateValue(for labels: UILabel...) {
        labels.forEach { (label) in
            switch label.tag {
            case 0: redValueLabel.text = string(value: redCurrentValue)
            case 1: greenValueLabel.text = string(value: greenCurrentValue)
            case 2: blueValueLabel.text = string(value: blueCurrentValue)
            default: break
            }
        }
    }
    
    func updateValue(for textFields: UITextField...) {
        textFields.forEach { (textField) in
            switch textField.tag {
            case 0: redTextField.text = string(value: redCurrentValue)
            case 1: greenTextField.text = string(value: greenCurrentValue)
            case 2: blueTextField.text = string(value: blueCurrentValue)
            default: break
            }
        }
    }
    
    func updateValue(for sliders: UISlider...) {
        sliders.forEach { (slider) in
            switch slider.tag {
            case 0: redSlider.value = Float(redCurrentValue)
            case 1: greenSlider.value = Float(greenCurrentValue)
            case 2: blueSlider.value = Float(blueCurrentValue)
            default: break
            }
        }
    }
    
}

extension ColorMixerViewController {
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            self.redTextField.text = String(format: "%.2f",self.redOldValue)
            self.greenTextField.text = String(format: "%.2f",self.greenOldValue)
            self.blueTextField.text = String(format: "%.2f",self.blueOldValue)
            print("Entered incoreect value")
        }
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
    }
}
