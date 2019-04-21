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
    }
    
    @objc func myTextFieldDidChange(_ textField: UITextField) {
        if let amountString = textField.text?.currencyInputFormatting() {
            textField.text = amountString
        }
    }
    
    @objc func showInfoScreen() {
        
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
                //singlePriceView.isHidden = false
            } else {
                //singleAddressView.isHidden = false
            }
            
        case rightBarItem:
            if (segmentedView.selectedSegmentIndex == 0) {
                //multiPriceView.isHidden = false
            } else {
                //multiAddressView.isHidden = false
            }
        default:
            break;
        }
    }
}
