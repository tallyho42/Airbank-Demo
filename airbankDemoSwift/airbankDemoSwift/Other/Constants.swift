//
//  Constants.swift
//  airbankDemoSwift
//
//  Created by Premysl Semerad on 02/11/15.
//  Copyright © 2015 Premysl Semerad. All rights reserved.
//

import UIKit

// MARK: Colors - General

let kColorGreen = UIColor(red: 0.518, green: 0.780, blue: 0.247, alpha: 1.00)

// MARK: Colors - Specific

let kColorNavBarBackground = kColorGreen
let kColorNavBarTint = UIColor.whiteColor()

// MARK: Fonts

func fontBold(size: CGFloat) -> UIFont {
    return UIFont(name: "HelveticaNeue-Bold", size: size)!
}

// MARK: Sizes

let kCellTransactionListHeight:CGFloat = 80.0
let kCellTransactionDetailHeight:CGFloat = 83.0