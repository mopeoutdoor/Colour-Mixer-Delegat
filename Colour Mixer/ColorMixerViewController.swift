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
    
    @IBOutlet weak var redLabel: UILabel!
    @IBOutlet weak var redValueLabel: UILabel!
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var redTextField: UITextField!
    
    @IBOutlet weak var greenLabel: UILabel!
    @IBOutlet weak var greenValueLabel: UILabel!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var greenTextField: UITextField!
    
    @IBOutlet weak var blueLabel: UILabel!
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
        
        //Red
        updateDefaultValue(colour: .red)
        updateCurrentValue(colour: .red)
        
        //Green
        updateDefaultValue(colour: .green)
        updateCurrentValue(colour: .green)
        
        //Blue
        updateDefaultValue(colour: .blue)
        updateCurrentValue(colour: .blue)
        
        //View
        view.backgroundColor = UIColor(red: redBoardValue, green: greenBoardValue, blue: blueBoardValue, alpha: alphaValue)
        
        colourView.backgroundColor = UIColor(red: redCurrentValue, green: greenCurrentValue, blue: blueCurrentValue, alpha: alphaValue)
        
        //Delegate
        redTextField.delegate = self
        greenTextField.delegate = self
        blueTextField.delegate = self
        
    }

    @IBAction func redSliderAction(_ sender: UISlider) {
        redCurrentValue = CGFloat(sender.value)
        updateCurrentValue(colour: .red)
        colourView.backgroundColor = UIColor(red: redCurrentValue, green: greenCurrentValue, blue: blueCurrentValue, alpha: alphaValue)
    }
    
    @IBAction func greenSliderAction(_ sender: UISlider) {
        greenCurrentValue = CGFloat(sender.value)
        updateCurrentValue(colour: .green)
        colourView.backgroundColor = UIColor(red: redCurrentValue, green: greenCurrentValue, blue: blueCurrentValue, alpha: alphaValue)
    }
    
    @IBAction func blueSliderAction(_ sender: UISlider) {
        blueCurrentValue = CGFloat(sender.value)
        updateCurrentValue(colour: .blue)
        colourView.backgroundColor = UIColor(red: redCurrentValue, green: greenCurrentValue, blue: blueCurrentValue, alpha: alphaValue)
    }
    
    @IBAction func didClickDoneButton(_ sender: UIBarButtonItem) {
        view.endEditing(true)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        textField.inputAccessoryView = toolbar
        
        return true
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
        
        let alertController = UIAlertController(title: "Warning!", message: "Value of colour must from 0.0 to 1.0. Please enter correct value.", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            self.redTextField.text = String(format: "%.2f",self.redOldValue)
            self.greenTextField.text = String(format: "%.2f",self.greenOldValue)
            self.blueTextField.text = String(format: "%.2f",self.blueOldValue)
            print("Entered incoreect value")
        }
        alertController.addAction(cancelAction)
        
        if let dbl = Double(textField.text!), dbl >= 0 && dbl <= 1 {
            currentValue = CGFloat(dbl)
            
            switch textField.accessibilityIdentifier {
            case "RedTextField":
                redCurrentValue = currentValue
                redSlider.value = Float(redCurrentValue)
                updateCurrentValue(colour: .red)
            case "GreenTextField":
                greenCurrentValue = currentValue
                greenSlider.value = Float(greenCurrentValue)
                updateCurrentValue(colour: .green)
            case "BlueTextField":
                blueCurrentValue = currentValue
                blueSlider.value = Float(blueCurrentValue)
                updateCurrentValue(colour: .blue)
            default:
                break
            }
            
            colourView.backgroundColor = UIColor(red: CGFloat(redCurrentValue), green: CGFloat(greenCurrentValue), blue: CGFloat(blueCurrentValue), alpha: alphaValue)
        } else {
            self.present(alertController, animated: true)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func updateCurrentValue(colour: RGB) {
        switch colour {
        case .red:
            redValueLabel.text = String(format: "%.2f",redCurrentValue)
            redTextField.text = String(format: "%.2f",redCurrentValue)
        case .green:
            greenValueLabel.text = String(format: "%.2f",greenCurrentValue)
            greenTextField.text = String(format: "%.2f",greenCurrentValue)
        case .blue:
            blueValueLabel.text = String(format: "%.2f",blueCurrentValue)
            blueTextField.text = String(format: "%.2f",blueCurrentValue)
        }
    }
    
    func updateDefaultValue(colour: RGB) {
        switch colour {
        case .red:
            redLabel.text = "Red:"
            redSlider.minimumTrackTintColor = UIColor.red
            redSlider.value = Float(redCurrentValue)
            redTextField.keyboardType = UIKeyboardType.decimalPad
            redTextField.textAlignment = .right
        case .green:
            greenLabel.text = "Green:"
            greenSlider.minimumTrackTintColor = UIColor.green
            greenSlider.value = Float(greenCurrentValue)
            greenTextField.keyboardType = UIKeyboardType.decimalPad
            greenTextField.textAlignment = .right
        case .blue:
            blueLabel.text = "Blue:"
            blueSlider.value = Float(blueCurrentValue)
            blueTextField.keyboardType = UIKeyboardType.decimalPad
            blueTextField.textAlignment = .right
        }
    }
    
}

