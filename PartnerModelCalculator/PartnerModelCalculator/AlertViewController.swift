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
    let viewRect = UIView()
    var frame: CGRect = CGRect(x:0, y:0, width:0, height:0)
    var pageControl = UIPageControl()
    let dismissButton = UIButton()
    
    let textsHeader = ["Welcome!", "What is Partnering?", "Next Steps"]
    let textsBody = ["With the help of this calculator, you will be able to compare the estimated costs and returns for the choice of renting, purchasing, or partnering to satisfy your housing needs for the next 30 years."
        ,"Partnering is an ownership program that allows you to buy a home through a direct investment in partnership shares.\n\nThis program offers many advantages over traditional financing options and does not require a mortgage.\n\nOwn the house - don't let the house own you!"
        , "Simply enter the fair market value or address for the house or houses you plan to occupy, noting that the average person will move 4 times over a 30 year period.\n\nOur calculator will do the rest!"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = UIScreen.main.bounds.width
        let height = UIScreen.main.bounds.height
        
        let width2 = 9 * width / 10
        let height2 = 4 * height / 7
        
        let x = (width - width2) / 2
        let y = (height - height2) / 2
        
        viewRect.frame = CGRect(x: 0, y: 0, width: width, height: height)
        viewRect.backgroundColor = UIColor.init(red: 118 / 255, green: 214 / 255, blue: 255 / 255, alpha: 1.0)
        viewRect.alpha = 0.85
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0.6
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(blurEffectView)
        
        self.view.addSubview(viewRect)
        
        scrollView.frame = CGRect(x: x, y: y, width: width2, height: height2)
        scrollView.sizeToFit()
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        //scrollView.backgroundColor = UIColor.init(red: 91.0/255.0, green: 127.0/255.0, blue: 138.0/255.0, alpha: 1)
        scrollView.layer.cornerRadius = 5
        scrollView.clipsToBounds = true
        
        self.view.addSubview(scrollView)
        
        pageControl.frame = CGRect(x: x, y: y + height2, width: width2, height: 30)
        self.pageControl.numberOfPages = 3
        self.pageControl.currentPage = 0
        self.pageControl.backgroundColor = UIColor.clear
        self.pageControl.pageIndicatorTintColor = UIColor.init(red: 91.0/255.0, green: 127.0/255.0, blue: 138.0/255.0, alpha: 1)
        self.pageControl.currentPageIndicatorTintColor = UIColor.white
        self.view.addSubview(pageControl)
        
        dismissButton.translatesAutoresizingMaskIntoConstraints = false
        dismissButton.alpha = 0.0
        dismissButton.addTarget(self, action: #selector(dismissPopUp), for: .touchUpInside)
        dismissButton.setTitle("Start Calculating!", for: .normal)
        dismissButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20.0)
        dismissButton.setTitleColor(UIColor.white, for: .normal)
        dismissButton.backgroundColor = UIColor.init(red: 91.0/255.0, green: 127.0/255.0, blue: 138.0/255.0, alpha: 1)
        self.view.addSubview(dismissButton)
        
        let verticalFormat = "V:|-" + y.description + "-[v0(" + height2.description + ")]"
        let horizontalFormat = "H:|-" + x.description + "-[v0(" + width2.description + ")]-|"

        self.view.addConstraintsWithFormat(format: verticalFormat, views: scrollView, pageControl, dismissButton)
        self.view.addConstraintsWithFormat(format: horizontalFormat, views: scrollView)
        self.view.addConstraintsWithFormat(format: horizontalFormat, views: pageControl)
        self.view.addConstraintsWithFormat(format: "H:|[v0]|", views: dismissButton)
        self.view.addConstraintsWithFormat(format: "V:[v1][v0(50)]|", views: dismissButton, pageControl)
        
        self.view.bringSubviewToFront(pageControl)
        
        for index in 0..<3 {
            
            frame.origin.x = self.scrollView.frame.size.width * CGFloat(index)
            frame.size = self.scrollView.frame.size
            
            let subView = UIView(frame: frame)
            subView.backgroundColor = UIColor.clear
            
            let topText = UILabel()
            topText.text = textsHeader[index]
            topText.textAlignment = .center
            topText.font = UIFont.boldSystemFont(ofSize: 32.0)
            topText.textColor = UIColor.white
            topText.backgroundColor = UIColor.clear
            
            let textBubble = UILabel()
            textBubble.translatesAutoresizingMaskIntoConstraints = false
            textBubble.text = textsBody[index]
            textBubble.font = UIFont.boldSystemFont(ofSize: 20.0)
            textBubble.textColor = UIColor.white
            textBubble.numberOfLines = 20
            textBubble.textAlignment = .center
            textBubble.backgroundColor = UIColor.clear
            subView.addSubview(textBubble)
            subView.addSubview(topText)
            subView.addConstraintsWithFormat(format: "H:|-[v0]-|", views: textBubble)
            subView.addConstraintsWithFormat(format: "H:|-[v0]-|", views: topText)
            subView.addConstraintsWithFormat(format: "V:[v1]-10-[v0]", views: textBubble, topText)
            self.scrollView.addSubview(subView)
        }
        
        self.scrollView.contentSize = CGSize(width:self.scrollView.frame.size.width * 3,height: self.scrollView.frame.size.height)
        self.scrollView.showsHorizontalScrollIndicator = false
        scrollView.sizeToFit()
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
        
        if (pageControl.currentPage == 2) {
            self.dismissButton.fadeIn()
        } else {
            self.dismissButton.fadeOut()
        }
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

    func fadeIn(_ duration: TimeInterval = 0.5, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
        }, completion: completion)  }
    
    func fadeOut(_ duration: TimeInterval = 0.5, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
        }, completion: completion)
    }
}
