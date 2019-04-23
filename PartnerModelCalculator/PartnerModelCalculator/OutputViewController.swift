//
//  OutputViewController.swift
//  PartnerModelCalculator
//
//  Created by Alex Wysoczanski on 4/21/19.
//  Copyright © 2019 Alex Wysoczanski. All rights reserved.
//

import UIKit

class ModelTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var numLabel: UILabel!
}

class OutputViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var partnerNums = ["a", "b", "c", "d"]
    var rentNums = ["e", "f", "g", "h"]
    var buyNums = ["i", "j", "k", "l"]
    
    var nums = [String]()//["", "", "", "", "", "", "", "", "", "", "", "", "", "", ""]
    
    var titles = ["Net Loss/Gain", "Partner Plan", "Rent", "Purchase", "Monthly Payment", "Partner Plan", "Rent", "Purchase", "Total Costs", "Partner Plan", "Rent", "Purchase", "Final Asset Value", "Partner Plan", "Rent", "Purchase"]
    
    var negative = [Bool]()

    @IBOutlet weak var table: UITableView!
    
    @IBOutlet weak var moreInfoButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.delegate = self
        table.dataSource = self
        self.table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        for i in 0...3 {
            nums.append("")
            nums.append(partnerNums[i])
            nums.append(rentNums[i])
            nums.append(buyNums[i])
        }
        
    }
    
    @IBAction func moreInfoButtonPress(_ sender: UIButton) {
        
        let message = "•A 30-year mortgage with a 20% down payment and 4.5% interest rate is automatically calculated on each transaction.\n•Monthly rent is calculated using a standard rate of 1% of the home's market price.\n•The Partner Plan is calculated assuming a 20% investment in partnership shares and a monthly partner fee of 0.6% of the home's market price.\n•Home appreciation is calculated using a 3% average annual return rate.\n•Partner shares are calculated using a 9% average annual return rate.\n•Total out-of-pocket costs include buyer closing fees, seller closing fees, property tax, home owner's insurance, and annual maintenance expenses based on market averages and increasing by 1% a year.\n•Adjustments are made for any assumed carried equity based on each individual transaction."
        
        let alert2 = UIAlertController(title: "Comparison Assumptions", message: message, preferredStyle: .alert)
        alert2.addAction(UIAlertAction(title: "Okay", style: .cancel, handler:nil))
        self.present(alert2, animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "partner", for: indexPath) as? ModelTableViewCell
        
        cell?.titleLabel.text = titles[indexPath.row]
        cell?.numLabel.text = nums[indexPath.row]
        
        if (indexPath.row % 4 == 0 ) {
            cell?.titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        } else {
            cell?.titleLabel.font = UIFont.systemFont(ofSize: 17)
        }
            
//        if negative[indexPath.row / 5] && indexPath.row % 5 == 1{
//            cell?.numLabel.textColor = UIColor.red
//        } else if !negative[indexPath.row / 5] && indexPath.row % 5 == 1 {
//            cell?.numLabel.textColor = UIColor.green
//        } else {
//            cell?.numLabel.textColor = UIColor.darkGray
//        }
        
        return cell!
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

}
