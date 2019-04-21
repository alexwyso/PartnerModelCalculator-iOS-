//
//  SingleCalculator.swift
//  PartnerModelCalculator
//
//  Created by Alex Wysoczanski on 4/20/19.
//  Copyright © 2019 Alex Wysoczanski. All rights reserved.
//

import Foundation

struct SingleCalculator {
    
    let price : Double?
    var partnerNums = ["", "", "", ""]
    var rentNums = ["", "", "", "$0.00"]
    var buyNums = ["", "", "", ""]
    
    init(priceInput : Double) {
        price = priceInput
        calculate()
    }
    
    mutating func calculate() {
        
        let annualCostIncrease = 0.0
        let annualReturnRate = 0.09
        var negative = [true, true, true]
        
        var monthly = 0.006 * price!
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        let formattedMonthly = numberFormatter.string(from: NSNumber(value: monthly))
        partnerNums[2] = "$" + formattedMonthly!
        
        var cost = 0.2 * price!
        for _ in 0...29 {
            cost += 12 * monthly
            monthly *= (1 + annualCostIncrease)
        }
        
        let formattedCost = numberFormatter.string(from: NSNumber(value: cost))
        partnerNums[1] = "$" + formattedCost!
        
        let gains = 0.2 * price! * pow(1 + annualReturnRate, 30)
        let formattedGains = numberFormatter.string(from: NSNumber(value: gains))
        partnerNums[3] = "$" + formattedGains!
        
        let netProf = gains - cost
        
        if (netProf < 0) {
            let formattedNet = numberFormatter.string(from: NSNumber(value: -1 * netProf))
            partnerNums[0] = "-($" + formattedNet! + ")"
            
        } else {
            negative[0] = false
            let formattedNet = numberFormatter.string(from: NSNumber(value: netProf))
            partnerNums[0] = "$" + formattedNet!
        }
        
        let formattedRent = numberFormatter.string(from: NSNumber(value: price! * 0.01))
        rentNums[2] = "$" + formattedRent!
        
        let formattedTotalRent = numberFormatter.string(from: NSNumber(value: 30 * 12 * price! * 0.01))
        rentNums[1] = "$" + formattedTotalRent!
        rentNums[0] = "-($" + formattedTotalRent! + ")"
        
        let i : Double = (0.045 / 12)
        let n : Double = (30 * 12)
        let propTax = 0.012
        let homeInsurance = 1200.00
        let otherCost = 250.00
        var totalOtherCosts = (homeInsurance / 12) + (propTax / 12 * price!) + otherCost
        
        let monMort : Double = (price! - (0.2 * price!)) * i * pow((i + 1), n) / (pow(1 + i, n) - 1)
        let plusExtra = monMort + totalOtherCosts
        
        let formattedMonthlyMortgage = numberFormatter.string(from: NSNumber(value: plusExtra))
        buyNums[2] = "$" + formattedMonthlyMortgage!
        
        var total : Double = 12 * monMort * 30
        
        for _ in 0...29 {
            total += 12 * totalOtherCosts
            totalOtherCosts = totalOtherCosts * 1.01
        }
        
        total += 0.025 * price!
        total += 0.2 * price!
        
        let formattedTotal = numberFormatter.string(from: NSNumber(value: total))
        buyNums[1] = "$" + formattedTotal!
        
        let salePrice = price! * pow(1.03, 30)
        let minusFees = 0.94 * salePrice
        let formattedSalesPrice = numberFormatter.string(from: NSNumber(value: minusFees))
        buyNums[3] = "$" + formattedSalesPrice!
        
        let netMortgageSum = minusFees - total
        
        if (netMortgageSum < 0) {
            
            let formattedNetMortgage = numberFormatter.string(from: NSNumber(value: -1 * netMortgageSum))
            buyNums[0] = "-($" + formattedNetMortgage! + ")"
            
        } else {
            negative[2] = false
            buyNums[0] = "$" + numberFormatter.string(from: NSNumber(value: netMortgageSum))!
        }
    }
}


