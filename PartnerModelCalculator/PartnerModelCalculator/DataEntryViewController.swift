//
//  DataEntryViewController.swift
//  PartnerModelCalculator
//
//  Created by Alex Wysoczanski on 4/20/19.
//  Copyright © 2019 Alex Wysoczanski. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

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

class DataEntryViewController: UIViewController, UITabBarDelegate {
    
    // Bars UI Elements
    @IBOutlet weak var segmentedView: UISegmentedControl!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var leftBarItem: UITabBarItem!
    @IBOutlet weak var rightBarItem: UITabBarItem!
    
    // Sinlge-Price UI Elements
    @IBOutlet weak var singlePriceView: UIView!
    @IBOutlet weak var spPriceTextField: UITextField!
    @IBOutlet weak var spPriceButton: UIView!
    
    // Multi-Price UI Elements
    @IBOutlet weak var multiPriceView: UIView!
    @IBOutlet weak var mpFirstPriceTextField: UITextField!
    @IBOutlet weak var mpSecondPriceTextField: UITextField!
    @IBOutlet weak var mpThirdPriceTextField: UITextField!
    @IBOutlet weak var mpFourthPriceTextField: UITextField!
    @IBOutlet weak var mpPriceButton: UIButton!
    
    // Single Address UI Elements
    @IBOutlet weak var singleAddressView: UIView!
    @IBOutlet weak var saMapView: MKMapView!
    @IBOutlet weak var saFirstPriceTextField: UITextField!
    @IBOutlet weak var saAddressButton: UIButton!
    
    // Multi-Address UI Elements
    @IBOutlet weak var multiAddressView: UIView!
    @IBOutlet weak var maMapView: MKMapView!
    @IBOutlet weak var maFirstPriceTextField: UITextField!
    @IBOutlet weak var maAddressButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBar.selectedItem = leftBarItem
        tabBar.delegate = self
        
        singlePriceView.isHidden = false
        singleAddressView.isHidden = true
        multiPriceView.isHidden = true
        multiAddressView.isHidden = true
        
        spPriceTextField.addTarget(self, action: #selector(myTextFieldDidChange), for: .editingChanged)
        mpFirstPriceTextField.addTarget(self, action: #selector(myTextFieldDidChange), for: .editingChanged)
        mpSecondPriceTextField.addTarget(self, action: #selector(myTextFieldDidChange), for: .editingChanged)
        mpThirdPriceTextField.addTarget(self, action: #selector(myTextFieldDidChange), for: .editingChanged)
        mpFourthPriceTextField.addTarget(self, action: #selector(myTextFieldDidChange), for: .editingChanged)
        
        let button = UIButton(type: .infoDark)
        button.addTarget(self, action: #selector(self.showInfoScreen), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
        
        let alert = UIAlertController(title: "Welcome!", message: "With the help of this calculator, you will be able to compare the estimated costs and returns for the choice of renting, purchasing, or partnering to satisfy your housing needs for the next 30 years.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Next", style: .default, handler: {
            _ in
            let alert2 = UIAlertController(title: "What is Partnering?", message: "Partnering is an ownership program that allows you to buy a home through a direct investment in partnership shares.\n\nThis program offers many advantages over traditional financing options and does not require a mortgage.\n\nOwn the house - don't let the house own you!", preferredStyle: .alert)
            alert2.addAction(UIAlertAction(title: "Next", style: .cancel, handler: {
                _ in
                let alert3 = UIAlertController(title: "Next Steps", message: "Simply enter the fair market value or address for the house or houses you plan to occupy, noting that the average person will move 4 times over a 30 year period.\n\nOur calculator will do the rest!", preferredStyle: .alert)
                alert3.addAction(UIAlertAction(title: "Okay", style: .cancel, handler:nil))
                self.present(alert3, animated: true, completion: nil)
            }))
            self.present(alert2, animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)

        
    }
    
    @objc func myTextFieldDidChange(_ textField: UITextField) {
        if let amountString = textField.text?.currencyInputFormatting() {
            textField.text = amountString
        }
    }
    
    @objc func showInfoScreen() {
        switch tabBar.selectedItem {
        case leftBarItem:
            if (segmentedView.selectedSegmentIndex == 0) {
                
                let alert = UIAlertController(title: "Enter the Price of Your Potential Future Home", message: "The results will allow you to compare the total out-of-pocket costs and benefits of renting, buying, or partnering on that property and remaining there until you cash out in the 30th year.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler:nil))
                self.present(alert, animated: true, completion: nil)
                
            } else {
                let alert = UIAlertController(title: "Enter the Address of Your Potential Future Home", message: "The results will allow you to compare the total out-of-pocket costs and benefits of renting, buying, or partnering on that property and remaining there until you cash out in the 30th year.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler:nil))
                self.present(alert, animated: true, completion: nil)
            }
            
        case rightBarItem:
            if (segmentedView.selectedSegmentIndex == 0) {
                let alert = UIAlertController(title: "Enter the Prices of Your Potential Future Homes", message: "The results will allow you to compare the total out-of-pocket costs and benefits of renting, buying, or partnering on a new home every 7.5 years with a final cash out in the 30th year.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Enter the Address of Your Potential Future Homes", message: "The results will allow you to compare the total out-of-pocket costs and benefits of renting, buying, or partnering on a new home every 7.5 years with a final cash out in the 30th year.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler:nil))
                self.present(alert, animated: true, completion: nil)
            }
        default:
            break;
        }
    }
    
    @IBAction func didSwitchSegment(_ sender: UISegmentedControl) {
        switch segmentedView.selectedSegmentIndex {
            case 0:
                if (tabBar.selectedItem == leftBarItem) {
                    singlePriceView.isHidden = false
                    multiPriceView.isHidden = true
                } else {
                    singlePriceView.isHidden = true
                    multiPriceView.isHidden = false
                }
                singleAddressView.isHidden = true
                multiAddressView.isHidden = true
            
            case 1:
                if (tabBar.selectedItem == leftBarItem) {
                    singleAddressView.isHidden = false
                    multiAddressView.isHidden = true
                } else {
                    singleAddressView.isHidden = true
                    multiAddressView.isHidden = false
                }
                singlePriceView.isHidden = true
                multiPriceView.isHidden = true
            default:
                break;
        }
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item {
            case leftBarItem:
                if (segmentedView.selectedSegmentIndex == 0) {
                    singlePriceView.isHidden = false
                    singleAddressView.isHidden = true
                } else {
                    singlePriceView.isHidden = true
                    singleAddressView.isHidden = false
                }
                multiPriceView.isHidden = true
                multiAddressView.isHidden = true
            
            case rightBarItem:
                if (segmentedView.selectedSegmentIndex == 0) {
                    multiPriceView.isHidden = false
                    multiAddressView.isHidden = true
                } else {
                    multiPriceView.isHidden = true
                    multiAddressView.isHidden = false
                }
                singlePriceView.isHidden = true
                singleAddressView.isHidden = true
            default:
                break;
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch tabBar.selectedItem {
        case leftBarItem:
            if (segmentedView.selectedSegmentIndex == 0) {
                let s1 = spPriceTextField!.text!.replacingOccurrences(of: ",", with: "")
                let first = Double(s1.replacingOccurrences(of: "$", with: ""))
                let data = SingleCalculator(priceInput: first!)
                
                let nextVC = segue.destination as! OutputViewController
                nextVC.partnerNums = data.partnerNums
                nextVC.rentNums = data.rentNums
                nextVC.buyNums = data.buyNums
                nextVC.negative = data.negative
            } else {
                //singleAddressView.isHidden = false
            }
            
        case rightBarItem:
            if (segmentedView.selectedSegmentIndex == 0) {
                
                let s1 = mpFirstPriceTextField!.text!.replacingOccurrences(of: ",", with: "")
                let s2 = mpSecondPriceTextField!.text!.replacingOccurrences(of: ",", with: "")
                let s3 = mpThirdPriceTextField!.text!.replacingOccurrences(of: ",", with: "")
                let s4 = mpFourthPriceTextField!.text!.replacingOccurrences(of: ",", with: "")
                
                let first = Double(s1.replacingOccurrences(of: "$", with: ""))
                let second = Double(s2.replacingOccurrences(of: "$", with: ""))
                let third = Double(s3.replacingOccurrences(of: "$", with: ""))
                let fourth = Double(s4.replacingOccurrences(of: "$", with: ""))
                
                let data = MultipleCalculator(priceInput: first!, price2Input: second!, price3Input: third!, price4Input: fourth!)
                
                let nextVC = segue.destination as! OutputViewController
                nextVC.partnerNums = data.partnerNums
                nextVC.rentNums = data.rentNums
                nextVC.buyNums = data.buyNums
                nextVC.negative = data.negative
                
            } else {
                //multiAddressView.isHidden = false
            }
        default:
            break;
        }
    }
}
