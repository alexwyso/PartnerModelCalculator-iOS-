//
//  TableSingleOutput.swift
//  PartnerModel
//
//  Created by Alex Wysoczanski on 4/16/19.
//  Copyright © 2019 Alex Wysoczanski. All rights reserved.
//

import UIKit

class PartnerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
}

class RentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var rentTitleLabel: UILabel!
    @IBOutlet weak var rentNumberLabel: UILabel!
}

class BuyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var buyTitleLabel: UILabel!
    @IBOutlet weak var buyNumberLabel: UILabel!
}

class TableSingleOutput: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var partnerTable: UITableView!
    @IBOutlet weak var buyTable: UITableView!
    @IBOutlet weak var rentTable: UITableView!
    
    var titles = [String]()
    var partnerNums = [String]()
    var rentNums = [String]()
    var buyNums = [String]()
    
    var negative = [Bool]()
    
    let annualReturnRate = 0.09
    var netProf = 0.0
    
    var price = ""
    var upfront = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        partnerTable.delegate = self
        partnerTable.dataSource = self
        
        rentTable.delegate = self
        rentTable.dataSource = self

        buyTable.delegate = self
        buyTable.dataSource = self
        
//        partnerTable.layer.cornerRadius = 15
//        buyTable.layer.cornerRadius = 15
//        rentTable.layer.cornerRadius = 15
        
        self.partnerTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.buyTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell1")
        self.rentTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell2")
        
        titles = ["Final Asset Value:", "Total Costs:", "Monthly Payment:", "Net Loss/Gain:"]
        
        partnerNums = ["$X.XX", "$X.XX", "$X.XX", "$X.XX"]
        rentNums = ["$0.00", "$X.XX", "$X.XX", "$X.XX"]
        buyNums = ["$X.XX", "$X.XX", "$X.XX", "$X.XX"]
        
        negative = [true, true, true]
        
        let annualCostIncrease = 0.0
        
        price = price.replacingOccurrences(of: "$", with: "")
        price = price.replacingOccurrences(of: ",", with: "")
        
        upfront = upfront.replacingOccurrences(of: "$", with: "")
        upfront = upfront.replacingOccurrences(of: ",", with: "")
        
        var currMonthly = round(0.006 * Double(price)!)
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        let formattedMonthly = numberFormatter.string(from: NSNumber(value: currMonthly))
        partnerNums[2] = "$" + formattedMonthly!
        
        var cost = Double(upfront)!
        for _ in 0...29 {
            cost += 12 * currMonthly
            currMonthly *= (1 + annualCostIncrease)
        }
        
        let formattedCost = numberFormatter.string(from: NSNumber(value: cost))
        partnerNums[1] = "$" + formattedCost!
        
        let gains = Double(upfront)! * pow(1 + annualReturnRate, 30)
        let formattedGains = numberFormatter.string(from: NSNumber(value: gains))
        partnerNums[0] = "$" + formattedGains!
        
        netProf = gains - cost
        
        if (netProf < 0) {
            let formattedNet = numberFormatter.string(from: NSNumber(value: -1 * netProf))
            partnerNums[3] = "-($" + formattedNet! + ")"
            
        } else {
            negative[0] = false
            let formattedNet = numberFormatter.string(from: NSNumber(value: netProf))
            partnerNums[3] = "$" + formattedNet!
        }
        
        let formattedRent = numberFormatter.string(from: NSNumber(value: Double(price)! * 0.01))
        rentNums[2] = "$" + formattedRent!
        
        let formattedTotalRent = numberFormatter.string(from: NSNumber(value: 30 * 12 * Double(price)! * 0.01))
        rentNums[1] = "$" + formattedTotalRent!
        rentNums[3] = "-($" + formattedTotalRent! + ")"
        
        let i : Double = (0.045 / 12)
        let n : Double = (30 * 12)
        let propTax = 0.012
        let homeInsurance = 1200.00
        let otherCost = 250.00
        var totalOtherCosts = (homeInsurance / 12) + (propTax / 12 * Double(price)!) + otherCost
        
        let monMort : Double = (Double(price)! - Double(upfront)!) * i * pow((i + 1), n) / (pow(1 + i, n) - 1)
        let plusExtra = monMort + totalOtherCosts
        
        let formattedMonthlyMortgage = numberFormatter.string(from: NSNumber(value: plusExtra))
        buyNums[2] = "$" + formattedMonthlyMortgage!
        
        var total : Double = 12 * monMort * 30
        
        for _ in 0...29 {
            total += 12 * totalOtherCosts
            totalOtherCosts = totalOtherCosts * 1.01
        }
        
        total += 0.025 * Double(price)!
        total += Double(upfront)!
        
        let formattedTotal = numberFormatter.string(from: NSNumber(value: total))
        buyNums[1] = "$" + formattedTotal!
        
        let salePrice = Double(price)! * pow(1.03, 30)
        let minusFees = 0.94 * salePrice
        let formattedSalesPrice = numberFormatter.string(from: NSNumber(value: minusFees))
        buyNums[0] = "$" + formattedSalesPrice!
        
        let netMortgageSum = minusFees - total
        
        if (netMortgageSum < 0) {
            
            let formattedNetMortgage = numberFormatter.string(from: NSNumber(value: -1 * netMortgageSum))
            buyNums[3] = "-($" + formattedNetMortgage! + ")"
            
        } else {
            negative[2] = false
            buyNums[3] = "$" + numberFormatter.string(from: NSNumber(value: netMortgageSum))!
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.partnerTable {
            let cell = tableView.dequeueReusableCell(withIdentifier: "partner", for: indexPath) as? PartnerTableViewCell
            
            cell?.titleLabel.text = titles[indexPath.row]
            cell?.numberLabel.text = partnerNums[indexPath.row]
            
            if negative[0] && indexPath.row == 3{
                cell?.numberLabel.textColor = UIColor.red
            }
            
            if !negative[0] && indexPath.row == 3{
                cell?.numberLabel.textColor = UIColor.green
            }
            
            return cell!
            
        } else if tableView == self.buyTable {
            let cell = tableView.dequeueReusableCell(withIdentifier: "buy", for: indexPath) as? BuyTableViewCell
            
            cell?.buyTitleLabel.text = titles[indexPath.row]
            cell?.buyNumberLabel.text = buyNums[indexPath.row]
            
            if negative[2] && indexPath.row == 3{
                cell?.buyNumberLabel.textColor = UIColor.red
            }
            
            if !negative[2] && indexPath.row == 3{
                cell?.buyNumberLabel.textColor = UIColor.green
            }
            
            return cell!
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "rent", for: indexPath) as? RentTableViewCell
            
            cell?.rentTitleLabel.text = titles[indexPath.row]
            cell?.rentNumberLabel.text = rentNums[indexPath.row]
            
            if negative[1] && indexPath.row == 3{
                cell?.rentNumberLabel.textColor = UIColor.red
            }
            
            if !negative[1] && indexPath.row == 3{
                cell?.rentNumberLabel.textColor = UIColor.green
            }
            
            return cell!
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

}
