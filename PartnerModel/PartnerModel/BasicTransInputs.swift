//
//  BasicTransInputs.swift
//  PartnerModel
//
//  Created by Alex Wysoczanski on 3/26/19.
//  Copyright © 2019 Alex Wysoczanski. All rights reserved.
//

import UIKit

extension String {
    
    // formatting text for currency textField
    func currencyInputFormatting() -> String {
        
        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        var amountWithPrefix = self
        
        // remove from String: "$", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count), withTemplate: "")
        
        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double / 100))
        
        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else {
            return ""
        }
        
        return formatter.string(from: number)!
    }
}


class BasicTransInputs: UIViewController {

    @IBOutlet weak var priceTextField: UITextField!
    
    @IBOutlet weak var upfrontPaymentTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        priceTextField.addTarget(self, action: #selector(myTextFieldDidChange), for: .editingChanged)
        upfrontPaymentTextField.addTarget(self, action: #selector(myTextFieldDidChange), for: .editingChanged)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
        if (priceTextField.text == "" || upfrontPaymentTextField.text == "") {
            
            let alert = UIAlertController(title: "Error", message: "Please fill out all required fields.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
        
        let nextVC = segue.destination as! TableSingleOutput
        nextVC.price = priceTextField.text!
        nextVC.upfront = upfrontPaymentTextField.text!
        
     }
    
    @objc func myTextFieldDidChange(_ textField: UITextField) {
        
        if let amountString = textField.text?.currencyInputFormatting() {
            textField.text = amountString
        }
    }
    
}
