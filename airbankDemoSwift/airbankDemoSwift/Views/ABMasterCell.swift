//
//  ABMasterCell.swift
//  airbankDemoSwift
//
//  Created by Premysl Semerad on 02/11/15.
//  Copyright © 2015 Premysl Semerad. All rights reserved.
//

import UIKit
import SnapKit

class ABMasterCell: UITableViewCell {

    var viewSeparator: UIView? = nil

    override func awakeFromNib() {
        super.awakeFromNib()

        self.backgroundColor = UIColor.whiteColor()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureSeparator(showSeparator: Bool) {
        if showSeparator {
            self.viewSeparator = UIView(frame: CGRectZero)
            self.viewSeparator?.backgroundColor = UIColor.lightGrayColor()
            self.contentView.addSubview(self.viewSeparator!)

            self.viewSeparator!.snp_makeConstraints{make in
                make.left.equalTo(50)
                make.right.equalTo(-50)
                make.bottom.equalTo(0)
                make.height.equalTo(1.0)
            }
        } else {
            self.viewSeparator?.removeFromSuperview()
        }
    }
}
