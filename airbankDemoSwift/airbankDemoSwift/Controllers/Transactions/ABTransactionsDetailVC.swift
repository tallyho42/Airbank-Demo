//
//  ABTransactionsDetailVC.swift
//  airbankDemoSwift
//
//  Created by Premysl Semerad on 02/11/15.
//  Copyright © 2015 Premysl Semerad. All rights reserved.
//

import UIKit

public class ABTransactionsDetailVC: ABMasterVC, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: ABMasterTableView!
    
    override public func viewDidLoad() {

        self.configureChild(self, title: "Detail")

        super.viewDidLoad()

        self.tableView.registerNib(UINib(nibName: "ABTransactionListCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "CellList")
        self.tableView.registerNib(UINib(nibName: "ABTransactionDetailCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "CellDetail")
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Class Initialization

    public class func instantiate() -> ABTransactionsDetailVC {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("TransactionDetailVC") as! ABTransactionsDetailVC
        return viewController
    }

    // MARK: TableView Data Source

    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        var cell: UITableViewCell? = nil

        if indexPath.row == 0 {
            let cellList = tableView.dequeueReusableCellWithIdentifier("CellList", forIndexPath: indexPath) as! ABTransactionListCell

            cellList.configureSeparator(true)

            cell = cellList
        } else if indexPath.row == 1 {
            let cellDetail = tableView.dequeueReusableCellWithIdentifier("CellDetail", forIndexPath: indexPath) as! ABTransactionDetailCell

            cell = cellDetail
        }

        guard let resultCell = cell else {
            log("error creating cell")
            return UITableViewCell()
        }

        return resultCell
    }

    // MARK: TableView Delegate

    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return kCellTransactionListHeight
        } else if indexPath.row == 1 {
            return kCellTransactionDetailHeight
        } else {
            log("error determining the height of cell")
            return 0
        }
    }
}