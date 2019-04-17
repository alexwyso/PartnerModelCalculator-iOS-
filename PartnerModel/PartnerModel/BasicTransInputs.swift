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

    @IBOutlet weak var segSwitch: UISegmentedControl!
    
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var singleView: UIView!
    @IBOutlet weak var multipleView: UIView!
    
    @IBOutlet weak var upfrontPaymentTextField: UITextField!
    
    @IBOutlet weak var priceTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        priceTextField.addTarget(self, action: #selector(myTextFieldDidChange), for: .editingChanged)
        upfrontPaymentTextField.addTarget(self, action: #selector(myTextFieldDidChange), for: .editingChanged)
        singleView.alpha = 0.0
        multipleView.alpha = 1.0
        
        let button = UIButton(type: .infoDark)
        button.addTarget(self, action: #selector(self.showInfoScreen), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    @IBAction func viewChanged(_ sender: UISegmentedControl) {
        
        
        switch segSwitch.selectedSegmentIndex {
        case 1:
            singleView.fadeIn()
            multipleView.fadeOut()
        case 0:
            singleView.fadeOut()
            multipleView.fadeIn()
        default:
            break;
        }
    }
    
    func addRightNavigationBarInfoButton() {
        
    }
    
    @objc func showInfoScreen() {
        switch segSwitch.selectedSegmentIndex {
        case 0:
            let alert = UIAlertController(title: "Single Home Transaction", message: "Enter the price of your future home and reasonable upfront investment. \n The results will allow you to compare the costs and benefits for renting, buying, or partnering on that property and remaining there until cash-out in the 30th year.", preferredStyle: .alert)
        
            alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
        
            self.present(alert, animated: true)
        case 1:
            let alert = UIAlertController(title: "Mutiple Home Transactions", message: "Enter the price of your future homes and reasonable upfront investment. \n The results will allow you to compare the costs and benefits for renting, buying, or partnering a new home every 7.5 years with a final cash-out in the 30th year.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
            
            self.present(alert, animated: true)
        default:
            break;
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
        if (priceTextField.text == "" || upfrontPaymentTextField.text == "") {
            
            let alert = UIAlertController(title: "Error", message: "Please fill out all required fields.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
        
        let nextVC = segue.destination as! TableSingleOutput
        nextVC.price = upfrontPaymentTextField.text!
        nextVC.upfront = priceTextField.text!
        
     }
    
    @objc func myTextFieldDidChange(_ textField: UITextField) {
        
        if let amountString = textField.text?.currencyInputFormatting() {
            textField.text = amountString
        }
    }
    
}
extension UIView {
    func fadeIn() {
        // Move our fade out code from earlier
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0 // Instead of a specific instance of, say, birdTypeLabel, we simply set [thisInstance] (ie, self)'s alpha
        }, completion: nil)
    }
    
    func fadeOut() {
        UIView.animate(withDuration: 1.0, delay: 0.0, options: UIView.AnimationOptions.curveEaseOut, animations: {
            self.alpha = 0.0
        }, completion: nil)
    }
}
