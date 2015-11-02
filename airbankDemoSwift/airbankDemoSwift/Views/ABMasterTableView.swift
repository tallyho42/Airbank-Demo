//
//  ABMasterTableView.swift
//  airbankDemoSwift
//
//  Created by Premysl Semerad on 02/11/15.
//  Copyright © 2015 Premysl Semerad. All rights reserved.
//

import UIKit

class ABMasterTableView: UITableView {

    override func awakeFromNib() {
        super.awakeFromNib()

        // Master sett
        self.separatorStyle = .None
        self.backgroundColor = UIColor(red: 0.969, green: 0.969, blue: 0.969, alpha: 1.00)
    }
}
