//
//  ABTransactionDetailCell.swift
//  airbankDemoSwift
//
//  Created by Premysl Semerad on 02/11/15.
//  Copyright © 2015 Premysl Semerad. All rights reserved.
//

import UIKit

class ABTransactionDetailCell: ABMasterCell {

    @IBOutlet weak var viewLoading: UIView!
    @IBOutlet weak var viewDetail: UIView!
    @IBOutlet weak var viewError: UIView!

    @IBOutlet weak var lblAccountNumberTitle: UILabel!
    @IBOutlet weak var lblAccountNumberValue: UILabel!
    @IBOutlet weak var lblNameTitle: UILabel!
    @IBOutlet weak var lblNameValue: UILabel!
    @IBOutlet weak var lblBankCodeTitle: UILabel!
    @IBOutlet weak var lblBankCodeValue: UILabel!
    @IBOutlet weak var lblError: UILabel!

    func configure() {
        self.selectionStyle = .None
    }

    func displayLoadingOrDetail(transaction: Transaction) {

        self.viewError.hidden = true

        if transaction.loadedDetail {
            self.viewDetail.hidden = false
            self.viewLoading.hidden = true

            // Titles
            // TODO: localize
            self.lblAccountNumberTitle.text = "Account number"
            self.lblNameTitle.text = "Account name"
            self.lblBankCodeTitle.text = "Bank code"

            // Values
            self.lblAccountNumberValue.text = transaction.contraAccountNumber
            self.lblNameValue.text = transaction.contraAccountName
            self.lblBankCodeValue.text = transaction.contraBankCode
            
        } else {
            self.viewDetail.hidden = true
            self.viewLoading.hidden = false
        }
    }

    func displayError(errString: String) {
        self.viewDetail.hidden = true
        self.viewLoading.hidden = true
        self.viewError.hidden = false

        self.lblError.text = errString
    }
}