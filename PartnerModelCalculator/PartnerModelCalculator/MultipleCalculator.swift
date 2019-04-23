//
//  MultipleCalculator.swift
//  PartnerModelCalculator
//
//  Created by Alex Wysoczanski on 4/20/19.
//  Copyright © 2019 Alex Wysoczanski. All rights reserved.
//

import Foundation

struct MultipleCalculator {
    
    let price : Double?
    let price2 : Double?
    let price3 : Double?
    let price4 : Double?
    var partnerNums = ["", "", "", ""]
    var rentNums = ["", "", "", "$0.00"]
    var buyNums = ["", "", "", ""]
    var negative = [false, false, false]
    
    init(priceInput : Double, price2Input : Double, price3Input : Double, price4Input : Double) {
        price = priceInput
        price2 = price2Input
        price3 = price3Input
        price4 = price4Input
        calculate()
    }
    
    mutating func calculate() {
        
        let annualCostIncrease = 0.0
        let annualReturnRate = 0.09
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        
        let currMonthly = 0.006 * price!
        let monthly2 = 0.006 * price2!
        let monthly3 = 0.006 * price3!
        let monthly4 = 0.006 * price4!
        let avgMonthly = 0.25 * (currMonthly + monthly2 + monthly3 + monthly4)
        
        let formattedMonthly = numberFormatter.string(from: NSNumber(value: avgMonthly))
        partnerNums[1] = "$" + formattedMonthly!
        
        let drop1 : Double = (0.2 * (price2! - price!))
        let drop2 : Double = (0.2 * (price3! - price2!))
        let drop3 : Double = (0.2 * (price4! - price3!))
        
        let totalDrop : Double = drop1 + drop2 + drop3
        
        let cost : Double = (avgMonthly * 30 * 12) + (0.2 * price!) + totalDrop
        
        
        // Update for other rates if nonzero
        //        var cost = Double(upfront)!
        //        for _ in 0...6 {
        //            cost += 12 * currMonthly
        //            currMonthly *= (1 + annualCostIncrease)
        //        }
        
        var gains = (0.2 * price!) * pow(1 + annualReturnRate, 7.5)
        gains += drop1
        gains *= pow(1 + annualReturnRate, 7.5)
        gains += drop2
        gains *= pow(1 + annualReturnRate, 7.5)
        gains += drop3
        gains *= pow(1 + annualReturnRate, 7.5)
        
        let netProf = gains - cost
        
        let formattedGains = numberFormatter.string(from: NSNumber(value: gains))
        partnerNums[3] = "$" + formattedGains!
        
        let formattedCosts = numberFormatter.string(from: NSNumber(value: cost))
        partnerNums[2] = "$" + formattedCosts!
        
        if (netProf < 0) {
            let formattedNet = numberFormatter.string(from: NSNumber(value: -1 * netProf))
            partnerNums[0] = "-($" + formattedNet! + ")"
            negative[0] = true
            
        } else {
            let formattedNet = numberFormatter.string(from: NSNumber(value: netProf))
            partnerNums[0] = "$" + formattedNet!
            negative[0] = false
        }
        
        // RENT
        
        let totalRentADJ = 0.01 * 7.5 * 12 * (price! + price2! + price3! + price4!)
        let formattedTotalRent = numberFormatter.string(from: NSNumber(value: totalRentADJ))
        rentNums[0] = "-($" + formattedTotalRent! + ")"
        negative[1] = true
        
        let formattedTotalRentCosts = numberFormatter.string(from: NSNumber(value: totalRentADJ))
        rentNums[2] = "$" + formattedTotalRentCosts!
        
        let formattedRent = numberFormatter.string(from: NSNumber(value: totalRentADJ / (30 * 12)))
        rentNums[1] = "$" + formattedRent!
        
        // MORTGAGE 1
        
        let i : Double = (0.045 / 12)
        let n : Double = (30 * 12)
        let propTax = 0.012
        let homeInsurance = 1200.00
        let otherCost = 250.00
        var totalOtherCosts = (homeInsurance / 12) + (propTax / 12 * price!) + otherCost
        
        let monMort : Double = (0.8 * price!) * i * pow((i + 1), n) / (pow(1 + i, n) - 1)
        let plusExtra = monMort //+ totalOtherCosts
        
        let formattedMonthlyMortgage = numberFormatter.string(from: NSNumber(value: plusExtra))
        buyNums[1] = "$" + formattedMonthlyMortgage!
        
        var total : Double = 12 * monMort * 7.5
        
        for _ in 0...6 {
            total += 12 * totalOtherCosts
            totalOtherCosts = totalOtherCosts * 1.01
        }
        total += 6 * totalOtherCosts
        total += 0.025 * price!
        
        let salePrice = price! * pow(1.03, 7.5)
        let minusFees = 0.94 * salePrice
        
        let mortgageValue = 0.8 * price! * pow(1.045, 7.5) - (12 * 7.5 * monMort)
        
        let net1 = minusFees - mortgageValue
        
        // Mortgage 2
        
        var totalOtherCosts2 = (homeInsurance / 12) + (propTax / 12 * price2!) + otherCost
        
        let monMort2 : Double = (0.8 * price2!) * i * pow((i + 1), n) / (pow(1 + i, n) - 1)
        
        var total2 : Double = 12 * monMort2 * 7.5
        
        for _ in 0...6 {
            total2 += 12 * totalOtherCosts2
            totalOtherCosts2 = totalOtherCosts2 * 1.01
        }
        total2 += 6 * totalOtherCosts2
        total2 += 0.025 * price2!
        
        let salePrice2 = price2! * pow(1.03, 7.5)
        let minusFees2 = 0.94 * salePrice2
        
        let mortgageValue2 = 0.8 * price2! * pow(1.045, 7.5) - (12 * 7.5 * monMort2)
        
        let net2 = minusFees2 - mortgageValue2
        
        // Mortgage 3
        
        var totalOtherCosts3 = (homeInsurance / 12) + (propTax / 12 * price3!) + otherCost
        
        let monMort3 : Double = (0.8 * price3!) * i * pow((i + 1), n) / (pow(1 + i, n) - 1)
        var total3 : Double = 12 * monMort3 * 7.5
        
        for _ in 0...6 {
            total3 += 12 * totalOtherCosts3
            totalOtherCosts3 = totalOtherCosts3 * 1.01
        }
        total3 += 6 * totalOtherCosts3
        total3 += 0.025 * price3!
        
        let salePrice3 = price3! * pow(1.03, 7.5)
        let minusFees3 = 0.94 * salePrice3
        
        let mortgageValue3 = 0.8 * price3! * pow(1.045, 7.5) - (12 * 7.5 * monMort3)
        
        let net3 = minusFees3 - mortgageValue3
        
        // Mortgage 4
        
        var totalOtherCosts4 = (homeInsurance / 12) + (propTax / 12 * price4!) + otherCost
        
        let monMort4 : Double = (0.8 * price4!) * i * pow((i + 1), n) / (pow(1 + i, n) - 1)
        
        var total4 : Double = 12 * monMort4 * 7.5
        
        for _ in 0...6 {
            total4 += 12 * totalOtherCosts4
            totalOtherCosts4 = totalOtherCosts4 * 1.01
        }
        total4 += 6 * totalOtherCosts4
        total4 += 0.025 * price4!
        
        let bigTotal = total + total2 + total3 + total4 + (0.2 * price!)
        
        let salePrice4 = price4! * pow(1.03, 7.5)
        let minusFees4 = 0.94 * salePrice4
        
        let mortgageValue4 = 0.8 * price4! * pow(1.045, 7.5) - (12 * 7.5 * monMort4)
        
        let net4 = minusFees4 - mortgageValue4
        
        let carry = (net1 - 0.2 * price2!) + (net2 - 0.2 * price3!) + (net3 - 0.2 * price4!)
        
        let netMortgageSum =  net4 + carry - bigTotal
        
        let formattedTotalBuyCosts = numberFormatter.string(from: NSNumber(value: bigTotal))
        buyNums[2] = "$" + formattedTotalBuyCosts!
        
        let formattedTotalBuyValue = numberFormatter.string(from: NSNumber(value: net4 + carry))
        buyNums[3] = "$" + formattedTotalBuyValue!
        
        // STAYS SAME
        
        buyNums[0] = "$" + numberFormatter.string(from: NSNumber(value: netMortgageSum))!
        
        if (netMortgageSum < 0) {
            negative[2] = true
            let formattedNetMortgage = numberFormatter.string(from: NSNumber(value: -1 * netMortgageSum))
            buyNums[0] = "-($" + formattedNetMortgage! + ")"
            
        } else {
            negative[2] = false
            buyNums[0] = "$" + numberFormatter.string(from: NSNumber(value: netMortgageSum))!
        }
    }
}
