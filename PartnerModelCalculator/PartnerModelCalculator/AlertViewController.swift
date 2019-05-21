//
//  AlertViewController.swift
//  PartnerModelCalculator
//
//  Created by Alex Wysoczanski on 4/23/19.
//  Copyright © 2019 Alex Wysoczanski. All rights reserved.
//

import UIKit

class AlertViewController: UIViewController, UIScrollViewDelegate {
    
    let scrollView = UIScrollView()
    let topText = UILabel()
    var frame: CGRect = CGRect(x:0, y:0, width:0, height:0)
    var pageControl = UIPageControl()
    
    let textsHeader = ["Welcome!", "What is Partnering?", "Next Steps"]
    let textsBody = ["With the help of this calculator, you will be able to compare the estimated costs and returns for the choice of renting, purchasing, or partnering to satisfy your housing needs for the next 30 years."
        ,"Partnering is an ownership program that allows you to buy a home through a direct investment in partnership shares.\n\nThis program offers many advantages over traditional financing options and does not require a mortgage.\n\nOwn the house - don't let the house own you!"
        , "Simply enter the fair market value or address for the house or houses you plan to occupy, noting that the average person will move 4 times over a 30 year period.\n\nOur calculator will do the rest!"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        
        let width2 = 5 * width / 6
        let height2 = 2 * height / 5
        
        let x = (width - width2) / 2
        let y = (height - height2) / 2
        
        scrollView.frame = CGRect(x: x, y: y, width: width2, height: height2)
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        
        topText.text = "How It Works"
        topText.textAlignment = .center
        topText.font = UIFont.systemFont(ofSize: 20.0)
        topText.textColor = UIColor.white
        topText.backgroundColor = UIColor.init(red: 91.0/255.0, green: 127.0/255.0, blue: 138.0/255.0, alpha: 1)
        
        self.view.addSubview(scrollView)
        
        pageControl.frame = CGRect(x: x, y: y + height2, width: width2, height: 30)
        self.pageControl.numberOfPages = 3
        self.pageControl.currentPage = 0
        self.pageControl.backgroundColor = UIColor.init(red: 151.0/255.0, green: 210.0/255.0, blue: 229.0/255.0, alpha: 1)
        self.pageControl.pageIndicatorTintColor = UIColor.init(red: 91.0/255.0, green: 127.0/255.0, blue: 138.0/255.0, alpha: 1)
        self.pageControl.currentPageIndicatorTintColor = UIColor.white
        self.view.addSubview(pageControl)
        self.view.addSubview(topText)
        
        let dismissButton = UIButton()
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.addTarget(self, action: #selector(dismissPopUp), for: .touchUpInside)
        dismissButton.setTitle("Dismiss", for: .normal)
        dismissButton.setTitleColor(UIColor.white, for: .normal)
        dismissButton.backgroundColor = UIColor.init(red: 91.0/255.0, green: 127.0/255.0, blue: 138.0/255.0, alpha: 1)
        self.view.addSubview(dismissButton)
        
        let verticalFormat = "V:|-" + y.description + "-[v0][v1(" + height2.description + ")][v2][v3]"
        let horizontalFormat = "H:|-" + x.description + "-[v0(" + width2.description + ")]-|"

        self.view.addConstraintsWithFormat(format: verticalFormat, views: topText, scrollView, pageControl, dismissButton)
        self.view.addConstraintsWithFormat(format: horizontalFormat, views: topText)
        self.view.addConstraintsWithFormat(format: horizontalFormat, views: scrollView)
        self.view.addConstraintsWithFormat(format: horizontalFormat, views: pageControl)
        self.view.addConstraintsWithFormat(format: horizontalFormat, views: dismissButton)
        
        self.view.bringSubviewToFront(pageControl)
        
        for index in 0..<3 {
            
            frame.origin.x = self.scrollView.frame.size.width * CGFloat(index)
            frame.size = self.scrollView.frame.size
            
            let subView = UIView(frame: frame)
            subView.backgroundColor = UIColor.init(red: 151.0/255.0, green: 210.0/255.0, blue: 229.0/255.0, alpha: 1)
            
            let textBubble = UILabel()
            textBubble.translatesAutoresizingMaskIntoConstraints = false
            textBubble.text = textsBody[index]
            textBubble.textColor = UIColor.black
            textBubble.numberOfLines = 20
            textBubble.textAlignment = .center
            textBubble.backgroundColor = UIColor.init(red: 151.0/255.0, green: 210.0/255.0, blue: 229.0/255.0, alpha: 1)
            subView.addSubview(textBubble)
            subView.addConstraintsWithFormat(format: "H:|-[v0]-|", views: textBubble)
            subView.addConstraintsWithFormat(format: "V:|-[v0]-|", views: textBubble)
            self.scrollView.addSubview(subView)
        }
        
        self.scrollView.contentSize = CGSize(width:self.scrollView.frame.size.width * 3,height: self.scrollView.frame.size.height)
        self.scrollView.showsHorizontalScrollIndicator = false
        pageControl.addTarget(self, action: #selector(self.changePage(sender:)), for: UIControl.Event.valueChanged)
    }
    
    @objc func dismissPopUp() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func changePage(sender: AnyObject) -> () {
        let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
        scrollView.setContentOffset(CGPoint(x:x, y:0), animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }


}
extension UIView {
    
    func addConstraintsWithFormat(format: String, views: UIView...) {
        
        var viewsDict = [String: UIView]()
        
        for (index, view) in views.enumerated() {
            
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDict["v\(index)"] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDict))
    }
    
    func addConstraintsFillEntireView(view: UIView) {
        addConstraintsWithFormat(format: "H:|[v0]|", views: view)
        addConstraintsWithFormat(format: "V:|[v0]|", views: view)
    }
}
