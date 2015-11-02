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

    var transactions: [Transaction] = [Transaction]()
    var rowCount: Int {
        return self.transactions.count
    }
    
    override func viewDidLoad() {

        self.configureChild(self, title: "List")

        super.viewDidLoad()

        self.tableView.registerNib(UINib(nibName: "ABTransactionListCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "CellTransaction")

        ABModelAPI.sharedInstance.call(ApiMethod(defaults: ApiMethodDefaults.TransactionsList),
        success: { response in
            if let arrTransactions = response.object as? [Transaction] {
                self.transactions = arrTransactions
                self.tableView.reloadData()
            }
        },
        failure: { error in
            // display error ...
        })
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

        let isLastCell:Bool = indexPath.row == self.rowCount-1
        let transaction = self.transactions[indexPath.row]
        
        cell.configureSeparator(!isLastCell)
        cell.configureAsListCell()
        cell.displayTransaction(transaction)

        return cell
    }

    // MARK: TableView Delegate 

    internal func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return kCellTransactionListHeight
    }

    internal func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        let transaction = self.transactions[indexPath.row]

        let detailVC = ABTransactionsDetailVC.instantiate(transaction)
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}