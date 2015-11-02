//
//  ABTransactionsListVC.swift
//  airbankDemoSwift
//
//  Created by Premysl Semerad on 02/11/15.
//  Copyright © 2015 Premysl Semerad. All rights reserved.
//

import UIKit

class ABTransactionsListVC: ABMasterVC, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: ABMasterTableView!

    var rowCount: Int {
        return 2
    }
    
    override func viewDidLoad() {

        self.configureChild(self, title: "List")

        super.viewDidLoad()

        self.tableView.registerNib(UINib(nibName: "ABTransactionListCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "CellTransaction")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: TableView Data Source

    internal func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.rowCount
    }

    internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CellTransaction", forIndexPath: indexPath) as! ABTransactionListCell

        cell.configureSeparator(indexPath.row == self.rowCount-1)

        return cell
    }

    // MARK: TableView Delegate 

    internal func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }

    internal func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}