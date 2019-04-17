//
//  MultiTransOutputDisplay.swift
//  PartnerModel
//
//  Created by Alex Wysoczanski on 4/11/19.
//  Copyright © 2019 Alex Wysoczanski. All rights reserved.
//

import UIKit

class MultiTransOutputDisplay: UIViewController {
    
    var price = ""
    var price2 = ""
    var price3 = ""
    var price4 = ""
    var upfront = ""
    
    @IBOutlet weak var net: UILabel!
    @IBOutlet weak var monthly: UILabel!
    
    @IBOutlet weak var totalRent: UILabel!
    @IBOutlet weak var monthlyRent: UILabel!
    
    @IBOutlet weak var netMortgage: UILabel!
    @IBOutlet weak var monthlyMortgage: UILabel!
    
    
    let annualReturnRate = 0.1
    
    var netProf = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let annualCostIncrease = 0.0
        
        price = price.replacingOccurrences(of: "$", with: "")
        price = price.replacingOccurrences(of: ",", with: "")
        
        price2 = price2.replacingOccurrences(of: "$", with: "")
        price2 = price2.replacingOccurrences(of: ",", with: "")
        
        price3 = price3.replacingOccurrences(of: "$", with: "")
        price3 = price3.replacingOccurrences(of: ",", with: "")
        
        price4 = price4.replacingOccurrences(of: "$", with: "")
        price4 = price4.replacingOccurrences(of: ",", with: "")
        
        upfront = upfront.replacingOccurrences(of: "$", with: "")
        upfront = upfront.replacingOccurrences(of: ",", with: "")
        
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        
        let currMonthly = 0.006 * Double(price)!
        let monthly2 = 0.006 * Double(price2)!
        let monthly3 = 0.006 * Double(price3)!
        let monthly4 = 0.006 * Double(price4)!
        let avgMonthly = 0.25 * (currMonthly + monthly2 + monthly3 + monthly4)
        
        let formattedMonthly = numberFormatter.string(from: NSNumber(value: avgMonthly))
        monthly.text = "$" + formattedMonthly!
        
        let drop1 : Double = (0.2 * (Double(price2)! - Double(price)!))
        let drop2 : Double = (0.2 * (Double(price3)! - Double(price2)!))
        let drop3 : Double = (0.2 * (Double(price4)! - Double(price3)!))
        
        let totalDrop : Double = drop1 + drop2 + drop3
        
        let cost : Double = (avgMonthly * 30 * 12) + Double(upfront)! + totalDrop
    
        
        // Update for other rates if nonzero
//        var cost = Double(upfront)!
//        for _ in 0...6 {
//            cost += 12 * currMonthly
//            currMonthly *= (1 + annualCostIncrease)
//        }
        
        var gains = Double(upfront)! * pow(1 + annualReturnRate, 7.5)
        gains += drop1
        gains *= pow(1 + annualReturnRate, 7.5)
        gains += drop2
        gains *= pow(1 + annualReturnRate, 7.5)
        gains += drop3
        gains *= pow(1 + annualReturnRate, 7.5)
        
        netProf = gains - cost
        
        if (netProf < 0) {
            net.textColor = UIColor.red
            let formattedNet = numberFormatter.string(from: NSNumber(value: -1 * netProf))
            net.text = "-($" + formattedNet! + ")"
            
        } else {
            net.textColor = UIColor.green
            let formattedNet = numberFormatter.string(from: NSNumber(value: netProf))
            net.text = "$" + formattedNet!
        }
        
        // RENT
        
        totalRent.textColor = UIColor.red
        let totalRentADJ = 0.01 * 7.5 * 12 * (Double(price)! + Double(price2)! + Double(price3)! + Double(price4)!)
        let formattedTotalRent = numberFormatter.string(from: NSNumber(value: totalRentADJ))
        totalRent.text = "-($" + formattedTotalRent! + ")"
        
        let formattedRent = numberFormatter.string(from: NSNumber(value: totalRentADJ / (30 * 12)))
        monthlyRent.text = "$" + formattedRent!
        
        // MORTGAGE 1
        
        let i : Double = (0.045 / 12)
        let n : Double = (30 * 12)
        let propTax = 0.012
        let homeInsurance = 1200.00
        let otherCost = 250.00
        var totalOtherCosts = (homeInsurance / 12) + (propTax / 12 * Double(price)!) + otherCost
        
        let monMort : Double = (Double(price)! - Double(upfront)!) * i * pow((i + 1), n) / (pow(1 + i, n) - 1)
        let plusExtra = monMort //+ totalOtherCosts
        
        let formattedMonthlyMortgage = numberFormatter.string(from: NSNumber(value: plusExtra))
        monthlyMortgage.text = "$" + formattedMonthlyMortgage!
        
        var total : Double = 12 * monMort * 7.5
        
        for _ in 0...6 {
            total += 12 * totalOtherCosts
            totalOtherCosts = totalOtherCosts * 1.01
        }
        total += 6 * totalOtherCosts
        total += 0.025 * Double(price)!
        
        let salePrice = Double(price)! * pow(1.03, 7.5)
        let minusFees = 0.94 * salePrice
        
        let mortgageValue = 0.8 * Double(price)! * pow(1.045, 7.5) - (12 * 7.5 * monMort)
        
        let net1 = minusFees - mortgageValue
        
        // Mortgage 2
        
        var totalOtherCosts2 = (homeInsurance / 12) + (propTax / 12 * Double(price2)!) + otherCost
        
        let monMort2 : Double = (0.8 * Double(price2)!) * i * pow((i + 1), n) / (pow(1 + i, n) - 1)

        var total2 : Double = 12 * monMort2 * 7.5
        
        for _ in 0...6 {
            total2 += 12 * totalOtherCosts2
            totalOtherCosts2 = totalOtherCosts2 * 1.01
        }
        total2 += 6 * totalOtherCosts2
        total2 += 0.025 * Double(price2)!
        
        let salePrice2 = Double(price2)! * pow(1.03, 7.5)
        let minusFees2 = 0.94 * salePrice2
        
        let mortgageValue2 = 0.8 * Double(price2)! * pow(1.045, 7.5) - (12 * 7.5 * monMort2)
        
        let net2 = minusFees2 - mortgageValue2

        // Mortgage 3
        
        var totalOtherCosts3 = (homeInsurance / 12) + (propTax / 12 * Double(price3)!) + otherCost
        
        let monMort3 : Double = (0.8 * Double(price3)!) * i * pow((i + 1), n) / (pow(1 + i, n) - 1)
        var total3 : Double = 12 * monMort3 * 7.5
        
        for _ in 0...6 {
            total3 += 12 * totalOtherCosts3
            totalOtherCosts3 = totalOtherCosts3 * 1.01
        }
        total3 += 6 * totalOtherCosts3
        total3 += 0.025 * Double(price3)!
        
        let salePrice3 = Double(price3)! * pow(1.03, 7.5)
        let minusFees3 = 0.94 * salePrice3
        
        let mortgageValue3 = 0.8 * Double(price3)! * pow(1.045, 7.5) - (12 * 7.5 * monMort3)
        
        let net3 = minusFees3 - mortgageValue3
        
        // Mortgage 4
        
        var totalOtherCosts4 = (homeInsurance / 12) + (propTax / 12 * Double(price4)!) + otherCost
        
        let monMort4 : Double = (0.8 * Double(price4)!) * i * pow((i + 1), n) / (pow(1 + i, n) - 1)
        
        var total4 : Double = 12 * monMort4 * 7.5
        
        for _ in 0...6 {
            total4 += 12 * totalOtherCosts4
            totalOtherCosts4 = totalOtherCosts4 * 1.01
        }
        total4 += 6 * totalOtherCosts4
        total4 += 0.025 * Double(price4)!
       
        let bigTotal = total + total2 + total3 + total4 + Double(upfront)!
        
        let salePrice4 = Double(price4)! * pow(1.03, 7.5)
        let minusFees4 = 0.94 * salePrice4
        
        let mortgageValue4 = 0.8 * Double(price4)! * pow(1.045, 7.5) - (12 * 7.5 * monMort4)
        
        let net4 = minusFees4 - mortgageValue4
        
        let carry = (net1 - 0.2 * Double(price2)!) + (net2 - 0.2 * Double(price3)!) + (net3 - 0.2 * Double(price4)!)
        
        print(carry)
        
        let netMortgageSum =  net4 + carry - bigTotal
        
        // STAYS SAME
        
        netMortgage.text = "$" + numberFormatter.string(from: NSNumber(value: netMortgageSum))!
        
        if (netMortgageSum < 0) {
            netMortgage.textColor = UIColor.red
            let formattedNetMortgage = numberFormatter.string(from: NSNumber(value: -1 * netMortgageSum))
            netMortgage.text = "-($" + formattedNetMortgage! + ")"
            
        } else {
            netMortgage.textColor = UIColor.green
            netMortgage.text = "$" + numberFormatter.string(from: NSNumber(value: netMortgageSum))!
        }
    }
}
