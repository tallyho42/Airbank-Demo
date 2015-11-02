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
    var refreshControl:UIRefreshControl!

    public var transaction: Transaction!
    public var errString: String? = nil

    override public func viewDidLoad() {

        self.configureChild(self, title: "Detail")

        super.viewDidLoad()

        self.tableView.registerNib(UINib(nibName: "ABTransactionListCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "CellList")
        self.tableView.registerNib(UINib(nibName: "ABTransactionDetailCell", bundle: NSBundle.mainBundle()), forCellReuseIdentifier: "CellDetail")

        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        self.tableView.addSubview(refreshControl)

        self.loadDetail()
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Class Initialization

    public class func instantiate(transaction: Transaction) -> ABTransactionsDetailVC {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("TransactionDetailVC") as! ABTransactionsDetailVC
        viewController.transaction = transaction
        return viewController
    }

    // MARK: Loading & refresh control

    func loadDetail() {
        ABModelAPI.sharedInstance.call(ApiMethod(defaults: ApiMethodDefaults.TransactionDetail, parameters: [ApiParameter(key: "id", value: self.transaction.id)]),
            success: { response in

                self.errString = nil

                if let detail = response.object as? Transaction {
                    self.transaction.appendDetailedTransaction(detail)
                    self.refreshControl.endRefreshing()
                    self.tableView.reloadData()
                }
            },
            failure: { error in
                // TODO: localize
                self.errString = "Během načítání dotazu nastala chyba. Opakujte prosím akci."
                self.refreshControl.endRefreshing()
                self.tableView.reloadData()
        })
    }

    func refresh(sender:AnyObject)
    {
        self.transaction.loadedDetail = false
        self.tableView.reloadData()
        self.loadDetail()
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
            cellList.configureAsDetailCell()
            cellList.displayTransaction(self.transaction)

            cell = cellList
        } else if indexPath.row == 1 {
            let cellDetail = tableView.dequeueReusableCellWithIdentifier("CellDetail", forIndexPath: indexPath) as! ABTransactionDetailCell

            cellDetail.configure()

            if let error = self.errString {
                cellDetail.displayError(error)
            } else {
                cellDetail.displayLoadingOrDetail(self.transaction)
            }

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