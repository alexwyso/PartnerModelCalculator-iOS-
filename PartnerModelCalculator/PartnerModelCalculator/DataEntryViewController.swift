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

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

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

class DataEntryViewController: UIViewController, UITabBarDelegate, MKMapViewDelegate, CLLocationManagerDelegate {
    
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
    
    private var locationManager: CLLocationManager!
    private var currentLocation: CLLocation?
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
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
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let myAlert = storyboard.instantiateViewController(withIdentifier: "alert")
        myAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        myAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve

        self.present(myAlert, animated: true, completion: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    
        self.hideKeyboardWhenTappedAround()
        
        saMapView.delegate = self
        maMapView.delegate = self
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        defer { currentLocation = locations.last }
        
        if currentLocation == nil {
            // Zoom to user location
            if let userLocation = locations.last {
                let viewRegion = MKCoordinateRegion(center: userLocation.coordinate, latitudinalMeters: 2000, longitudinalMeters: 2000)
                saMapView.setRegion(viewRegion, animated: true)
                saMapView.showsUserLocation = true
                maMapView.setRegion(viewRegion, animated: true)
                maMapView.showsUserLocation = true
            }
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if heightConstraint.constant == 1 {
                heightConstraint.constant = keyboardSize.height
                self.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if heightConstraint.constant != 1 {
            heightConstraint.constant = 1
            self.view.layoutIfNeeded()
        }
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
    
    func displayAlert() {
        let alert = UIAlertController(title: "Invalid Entry", message: "Please complete all required fields.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch tabBar.selectedItem {
        case leftBarItem:
            if (segmentedView.selectedSegmentIndex == 0) {
                let s1 = spPriceTextField!.text!.replacingOccurrences(of: ",", with: "")
                let first = Double(s1.replacingOccurrences(of: "$", with: ""))
                if first != nil {
                    let data = SingleCalculator(priceInput: first!)
                    let nextVC = segue.destination as! OutputViewController
                    nextVC.partnerNums = data.partnerNums
                    nextVC.rentNums = data.rentNums
                    nextVC.buyNums = data.buyNums
                    nextVC.negative = data.negative
                } else {
                    displayAlert()
                }
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
                
                if (first != nil && second != nil && third != nil && fourth != nil) {
                
                    let data = MultipleCalculator(priceInput: first!, price2Input: second!, price3Input: third!, price4Input: fourth!)
                    
                    let nextVC = segue.destination as! OutputViewController
                    nextVC.partnerNums = data.partnerNums
                    nextVC.rentNums = data.rentNums
                    nextVC.buyNums = data.buyNums
                    nextVC.negative = data.negative
                    
                } else {
                    displayAlert()
                }
                
            } else {
                //multiAddressView.isHidden = false
            }
        default:
            break;
        }
    }
}
