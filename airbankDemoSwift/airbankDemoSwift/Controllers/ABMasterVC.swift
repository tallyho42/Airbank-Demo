//
//  ABMasterVC.swift
//  airbankDemoSwift
//
//  Created by Premysl Semerad on 02/11/15.
//  Copyright © 2015 Premysl Semerad. All rights reserved.
//

import UIKit

public class ABMasterVC: UIViewController {

    private weak var child: ABMasterVC? = nil
    private var titleForNavBar: String? = nil

    override public func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        if self.child == nil {
            log("WARNING: No ABMaster Child set! View Hierarchy may be corrupted...")
        }

        self.configureNavigationBar()
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Child methods

    func configureChild(newChild: ABMasterVC, title: String? = nil) {
        self.child = newChild
        self.titleForNavBar = title
    }

    // MARK: Navigation Bar & Status Bar

    func configureNavigationBar() {

        self.navigationController?.navigationBar.barTintColor = kColorNavBarBackground
        self.navigationController?.navigationBar.tintColor = kColorNavBarTint

        if let title = self.titleForNavBar {
            let lblTitle = UILabel(frame:CGRectMake(0, 0, 200, 40))
            lblTitle.backgroundColor = UIColor.clearColor()
            lblTitle.textColor = kColorNavBarTint
            lblTitle.font = fontBold(20.0)
            lblTitle.textAlignment = .Center
            lblTitle.text = title
            self.navigationItem.titleView = lblTitle
        }
    }

    public override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

    // MARK: Formatting

    class func formatAmount(amount: Double, decimals: Bool, currency: Bool) -> String {
        // This function could and should be done way better, but for this demo purpose it's propably fine
        let amountFormatter = NSNumberFormatter()

        var format = "00"

        if decimals {
            format += ".00"
        }

        if currency {
            format += " Kč"
        }

        amountFormatter.positiveFormat = format
        amountFormatter.negativeFormat = "- \(format)"
        return amountFormatter.stringFromNumber(NSNumber(double: amount))!
    }
}