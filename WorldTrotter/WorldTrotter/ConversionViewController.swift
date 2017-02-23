//
//  ConversionViewController.swift
//  WorldTrotter
//
//  Created by Hisham Abraham on 2/13/17.
//  Copyright © 2017 Hisham Abraham. All rights reserved.
//

import UIKit

class ConversionViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var celsiusLable: UILabel!
    @IBOutlet weak var textBox: UITextField!
    
    
    let numberFormatter: NumberFormatter = {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.minimumFractionDigits = 0
        nf.maximumFractionDigits = 1
        return nf
    }()
    
    var fahrenheightValue: Measurement<UnitTemperature>? {
        didSet{
            updateCelsiusLable()
        }
    }
    
    var celsiusValue: Measurement<UnitTemperature>? {
        if let fahrenheightValue = fahrenheightValue{
           return fahrenheightValue.converted(to: .celsius)
        }else{
            return nil
        }
    }
    
    func updateCelsiusLable(){
        if let celsiusValue = celsiusValue {
            celsiusLable.text =
                numberFormatter.string(from: NSNumber(value: celsiusValue.value))
        }else{
            celsiusLable.text = "???"
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentLocal = Locale.current
        let decimalSeparator = currentLocal.decimalSeparator ?? "."
        
        let existingTextHasDecimalSeparator = textField.text?.range( of: decimalSeparator)
        let replacementTextHasDecimalSeparator = string.range( of: decimalSeparator)
        if existingTextHasDecimalSeparator != nil,
        replacementTextHasDecimalSeparator != nil {
            return false
        } else {
            return true
        }
        
        
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(" ConversionViewController loaded its view.")
        
        updateCelsiusLable()
    }
    
    @IBAction func fahrenheightFieldEditingChanged(_ textField: UITextField){
        
        if let text = textField.text, let number = numberFormatter.number(from: text){
            fahrenheightValue = Measurement(value: number.doubleValue, unit: .fahrenheit)
        }else{
            fahrenheightValue = nil
        }
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer){
        textBox.resignFirstResponder()
    }
    
    
    
}
