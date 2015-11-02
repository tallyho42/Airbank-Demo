//
//  ABTransactionListCell.swift
//  airbankDemoSwift
//
//  Created by Premysl Semerad on 02/11/15.
//  Copyright © 2015 Premysl Semerad. All rights reserved.
//

import UIKit

class ABTransactionListCell: ABMasterCell {

    @IBOutlet weak var imvIcon: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubtitle: UILabel!
    @IBOutlet weak var imvChevron: UIImageView!

    func configureAsListCell() {
        self.imvChevron.hidden = false
        self.selectionStyle = .Gray
    }

    func configureAsDetailCell() {
        self.imvChevron.hidden = true
        self.selectionStyle = .None
    }

    func displayTransaction(transaction: Transaction) {
        self.imvIcon.image = transaction.direction.iconForCell()
        self.lblTitle.text = ABMasterVC.formatAmount(transaction.amountInAccountCurrency, decimals: true, currency: true)
        self.lblSubtitle.text = transaction.direction.titleForCell()
    }
}