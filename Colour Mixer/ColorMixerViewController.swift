//
//  ViewController.swift
//  Colour Mixer
//
//  Created by Irina Kopchenova on 01.02.2020.
//  Copyright © 2020 Mikhail Scherbina. All rights reserved.
//

import UIKit

class ColorMixerViewController: UIViewController, UITextFieldDelegate {
    var color: UIColor!
    
    let colourMinimumValue:Float = 0
    let colourMaximumValue:Float = 1
    
    let alphaValue:CGFloat = 1
    
    let redBoardValue:CGFloat = 0
    let greenBoardValue:CGFloat = 0.27
    let blueBoardValue:CGFloat = 0.56
    
    var redOldValue: Float = 0
    var greenOldValue: Float = 0
    var blueOldValue: Float = 0
    
    var redCurrentValue:Float = 0.76
    var greenCurrentValue:Float = 0.26
    var blueCurrentValue:Float = 0.49
    
    enum RGB {
        case red
        case green
        case blue
    }
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        colourView.layer.cornerRadius = 10
        //redCurrentValue = color.getRed(<#T##red: UnsafeMutablePointer<CGFloat>?##UnsafeMutablePointer<CGFloat>?#>, green: <#T##UnsafeMutablePointer<CGFloat>?#>, blue: <#T##UnsafeMutablePointer<CGFloat>?#>, alpha: <#T##UnsafeMutablePointer<CGFloat>?#>)
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
        self.view.backgroundColor = UIColor(red: redBoardValue, green: greenBoardValue, blue: blueBoardValue, alpha: alphaValue)
        
        colourView.backgroundColor = UIColor(red: CGFloat(redCurrentValue), green: CGFloat(greenCurrentValue), blue: CGFloat(blueCurrentValue), alpha: alphaValue)
        
        //Delegate
        redTextField.delegate = self
        greenTextField.delegate = self
        blueTextField.delegate = self
        
    }

    @IBAction func redSliderAction(_ sender: UISlider) {
        redCurrentValue = sender.value
        updateCurrentValue(colour: .red)
        colourView.backgroundColor = UIColor(red: CGFloat(redCurrentValue), green: CGFloat(greenCurrentValue), blue: CGFloat(blueCurrentValue), alpha: alphaValue)
    }
    
    @IBAction func greenSliderAction(_ sender: UISlider) {
        greenCurrentValue = sender.value
        updateCurrentValue(colour: .green)
        colourView.backgroundColor = UIColor(red: CGFloat(redCurrentValue), green: CGFloat(greenCurrentValue), blue: CGFloat(blueCurrentValue), alpha: alphaValue)
    }
    
    @IBAction func blueSliderAction(_ sender: UISlider) {
        blueCurrentValue = sender.value
        updateCurrentValue(colour: .blue)
        colourView.backgroundColor = UIColor(red: CGFloat(redCurrentValue), green: CGFloat(greenCurrentValue), blue: CGFloat(blueCurrentValue), alpha: alphaValue)
    }
    
    @IBAction func didClickDoneButton(_ sender: UIBarButtonItem) {
        view.endEditing(true)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        textField.inputAccessoryView = toolbar
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("Begin editing text field")
        redOldValue = redCurrentValue
        greenOldValue = greenCurrentValue
        blueOldValue = blueCurrentValue
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        var currentValue: Float
        
        let alertController = UIAlertController(title: "Warning!", message: "Value of colour must from 0.0 to 1.0. Please enter correct value.", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            self.redTextField.text = String(format: "%.2f",self.redOldValue)
            self.greenTextField.text = String(format: "%.2f",self.greenOldValue)
            self.blueTextField.text = String(format: "%.2f",self.blueOldValue)
            print("Entered incoreect value")
        }
        alertController.addAction(cancelAction)
        
        if let dbl = Double(textField.text!), dbl >= 0 && dbl <= 1 {
            currentValue = Float(dbl)
            
            switch textField.accessibilityIdentifier {
            case "RedTextField":
                redCurrentValue = currentValue
                redSlider.value = redCurrentValue
                updateCurrentValue(colour: .red)
            case "GreenTextField":
                greenCurrentValue = currentValue
                greenSlider.value = greenCurrentValue
                updateCurrentValue(colour: .green)
            case "BlueTextField":
                blueCurrentValue = currentValue
                blueSlider.value = blueCurrentValue
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
        //print("Tap by screen")
        self.view.endEditing(true)
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
            redSlider.minimumValue = colourMinimumValue
            redSlider.maximumValue = colourMaximumValue
            redSlider.minimumTrackTintColor = UIColor.red
            redSlider.maximumTrackTintColor = UIColor.white
            redSlider.value = redCurrentValue
            redTextField.keyboardType = UIKeyboardType.decimalPad
            redTextField.textAlignment = .right
        case .green:
            greenLabel.text = "Green:"
            greenSlider.minimumValue = colourMinimumValue
            greenSlider.maximumValue = colourMaximumValue
            greenSlider.minimumTrackTintColor = UIColor.green
            greenSlider.maximumTrackTintColor = UIColor.white
            greenSlider.value = greenCurrentValue
            greenTextField.keyboardType = UIKeyboardType.decimalPad
            greenTextField.textAlignment = .right
        case .blue:
            blueLabel.text = "Blue:"
            blueSlider.minimumValue = colourMinimumValue
            blueSlider.maximumValue = colourMaximumValue
            blueSlider.minimumTrackTintColor = UIColor.blue
            blueSlider.maximumTrackTintColor = UIColor.white
            blueSlider.value = blueCurrentValue
            blueTextField.keyboardType = UIKeyboardType.decimalPad
            blueTextField.textAlignment = .right
        }
    }
    
}

