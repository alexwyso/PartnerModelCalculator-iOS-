//
//  MultiTransInputs.swift
//  PartnerModel
//
//  Created by Alex Wysoczanski on 4/11/19.
//  Copyright © 2019 Alex Wysoczanski. All rights reserved.
//

import UIKit

class MultiTransInputs: UIViewController {
    

    @IBOutlet weak var upfrontPaymentTextField: UITextField!
    
    @IBOutlet weak var priceTextField: UITextField!
    
    @IBOutlet weak var price2TextField: UITextField!
    
    
    @IBOutlet weak var price3TextField: UITextField!
    
    @IBOutlet weak var price4TextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        priceTextField.addTarget(self, action: #selector(myTextFieldDidChange), for: .editingChanged)
        price2TextField.addTarget(self, action: #selector(myTextFieldDidChange), for: .editingChanged)
        price3TextField.addTarget(self, action: #selector(myTextFieldDidChange), for: .editingChanged)
        price4TextField.addTarget(self, action: #selector(myTextFieldDidChange), for: .editingChanged)
        upfrontPaymentTextField.addTarget(self, action: #selector(myTextFieldDidChange), for: .editingChanged)
        
        let tap : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if price4TextField.isEditing || price3TextField.isEditing {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y == 0 {
                    self.view.frame.origin.y -= keyboardSize.height / 2
                }
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (priceTextField.text == "" || price2TextField.text == "" || price3TextField.text == "" || price4TextField.text == "" || upfrontPaymentTextField.text == "") {
            
            let alert = UIAlertController(title: "Error", message: "Please fill out all required fields.", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Okay", style: .cancel, handler: nil))
            self.present(alert, animated: true)
        }
        
        let nextVC = segue.destination as! MultiTransOutputDisplay
        nextVC.price = priceTextField.text!
        nextVC.price2 = price2TextField.text!
        nextVC.price3 = price3TextField.text!
        nextVC.price4 = price4TextField.text!
        nextVC.upfront = upfrontPaymentTextField.text!
        
    }
    
    @objc func myTextFieldDidChange(_ textField: UITextField) {
        
        if let amountString = textField.text?.currencyInputFormatting() {
            textField.text = amountString
        }
    }
    
}

