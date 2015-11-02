//
//  Transaction.swift
//  airbankDemoSwift
//
//  Created by Premysl Semerad on 02/11/15.
//  Copyright © 2015 Premysl Semerad. All rights reserved.
//

import Foundation
import UIKit

enum TransactionDirection {
    case Incoming
    case Outgoing

    init?(apiString: String?) {
        guard let string = apiString  else {
            return nil
        }

        switch string {
        case "INCOMING":
            self = .Incoming
        case "OUTGOING":
            self = .Outgoing
        default:
            return nil
        }
    }

    func titleForCell() -> String {
        // TODO: localize

        switch self {
        case .Incoming:
            return "Incoming"
        case .Outgoing:
            return "Outgoing"
        }
    }

    func iconForCell() -> UIImage {
        switch self {
        case .Incoming:
            return UIImage(named: "icnTransactionIncoming")!
        case .Outgoing:
            return UIImage(named: "icnTransactionOutgoing")!
        }
    }
}

public class Transaction: ApiGeneralObjectProtocol {
    let id:Int
    let direction: TransactionDirection
    let amountInAccountCurrency: Double

    var loadedDetail:Bool = false

    required public init?(apiDict: AnyObject?) {

        var apiId: Int? = nil
        var apiDirection: TransactionDirection? = nil
        var apiAmount: Double? = nil

        if let dict = apiDict as? APIDict {
            if  let id = apiSafeIntFromDict(dict, key: "id"),
                let direction = TransactionDirection(apiString: apiSafeStringFromDict(dict, key: "direction")),
                let amount = apiSafeDoubleFromDict(dict, key: "amountInAccountCurrency") {
                    apiId = id
                    apiDirection = direction
                    apiAmount = amount
            }
        }

        if let id = apiId, direction = apiDirection, amount = apiAmount {
            self.id = id
            self.direction = direction
            self.amountInAccountCurrency = amount
        } else {
            self.id = 0
            self.direction = .Incoming
            self.amountInAccountCurrency = 0

            return nil
        }
    }
}