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
    var frame: CGRect = CGRect(x:0, y:0, width:0, height:0)
    var pageControl = UIPageControl()
    
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
        
        self.view.addSubview(scrollView)
        
        pageControl.frame = CGRect(x: x, y: y + height2, width: width2, height: 30)
        self.pageControl.numberOfPages = 3
        self.pageControl.currentPage = 0
        self.pageControl.tintColor = UIColor.red
        self.pageControl.pageIndicatorTintColor = UIColor.black
        self.pageControl.currentPageIndicatorTintColor = UIColor.green
        self.view.addSubview(pageControl)
        
        
        for index in 0..<3 {
            
            frame.origin.x = self.scrollView.frame.size.width * CGFloat(index)
            frame.size = self.scrollView.frame.size
            
            let subView = UIView(frame: frame)
            subView.backgroundColor = UIColor.lightGray
            
            let dismissButton = UIButton()
            dismissButton.translatesAutoresizingMaskIntoConstraints = false
            dismissButton.addTarget(self, action: #selector(dismissPopUp), for: .touchUpInside)
            dismissButton.setTitle("Dismiss", for: .normal)
            dismissButton.backgroundColor = UIColor.white
            subView.addSubview(dismissButton)
            subView.addConstraintsWithFormat(format: "H:|-50-[v0]-50-|", views: dismissButton)
            subView.addConstraintsWithFormat(format: "V:|-50-[v0]-50-|", views: dismissButton)
            self.scrollView.addSubview(subView)
        }
        
        self.scrollView.contentSize = CGSize(width:self.scrollView.frame.size.width * 3,height: self.scrollView.frame.size.height)
        pageControl.addTarget(self, action: #selector(self.changePage(sender:)), for: UIControl.Event.valueChanged)
        
    }
    
    @objc func dismissPopUp() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK : TO CHANGE WHILE CLICKING ON PAGE CONTROL
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
