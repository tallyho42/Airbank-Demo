//
//  ABMasterVC.swift
//  airbankDemoSwift
//
//  Created by Premysl Semerad on 02/11/15.
//  Copyright © 2015 Premysl Semerad. All rights reserved.
//

import UIKit

class ABMasterVC: UIViewController {

    private weak var child: ABMasterVC? = nil
    private var titleForNavBar: String? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        if self.child == nil {
            log("WARNING: No ABMaster Child set! View Hierarchy may be corrupted...")
        }

        self.configureNavigationBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Child methods

    func configureChild(newChild: ABMasterVC, title: String? = nil) {
        self.child = newChild
        self.titleForNavBar = title
    }

    // MARK: Navigation Bar

    func configureNavigationBar() {

    }

}