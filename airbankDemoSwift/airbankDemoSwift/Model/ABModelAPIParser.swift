//
//  ABModelAPIParser.swift
//  airbankDemoSwift
//
//  Created by Premysl Semerad on 02/11/15.
//  Copyright © 2015 Premysl Semerad. All rights reserved.
//

import Foundation

typealias Parser = (responseObject: AnyObject?) -> ParseResponse
typealias APIDict = [String: AnyObject]

protocol ApiGeneralObjectProtocol {
    init?(apiDict: AnyObject?)
}

// MARK: API Helpers
/*
    API Helpers
    - general helpers for parsing
    - these functions handle parsing which is always API-specific
    - for example some backends return (incorrectly) "null" instead of null -> so normally it would be parsed like a string. These simple functions assure that those errors doesn't happen
*/

func apiSafeStringFromDict(dict: APIDict, key: String) -> String? {
    let result: AnyObject? = dict[key]
    if let strResult = result as? String {

        if strResult == "<null>" {
            return nil
        }

        return strResult
    } else if let numResult = result as? NSNumber {
        log("parse warning: key \(key) is number instead of string - \(result)")
        return "\(numResult)"
    }

    return nil
}

func apiSafeIntFromDict(dict: APIDict, key: String) -> Int? {
    let result: AnyObject? = dict[key]
    if let numResult = result as? Int {
        return numResult
    } else if let strResult = result as? String {
        log("parse warning: key \(key) is string instead of int - \(result)")
        return Int(strResult)
    }

    return nil
}

func apiSafeDoubleFromDict(dict: APIDict, key: String) -> Double? {
    let result: AnyObject? = dict[key]
    if let numResult = result as? Double {
        return numResult
    } else if let strResult = result as? String {
        log("parse warning: key \(key) is string instead of double - \(result)")
        return Double(strResult)
    }

    return nil
}

func apiSafeBoolFromDict(dict: APIDict, key: String) -> Bool? {
    let result: AnyObject? = dict[key]

    if let numResult = result as? NSNumber {
        return numResult.boolValue
    }

    return nil
}

func apiSafeDictFromDict(dict: APIDict, key: String) -> APIDict? {
    let result: AnyObject? = dict[key]
    if let dictResult = result as? APIDict {
        return dictResult
    }

    return nil
}

func apiSafeArrayFromDict(dict: APIDict, key: String) -> [AnyObject]? {
    let result: AnyObject? = dict[key]
    if let arrResult = result as? [AnyObject] {
        return arrResult
    }

    return nil
}

func apiSafeDateFromDict(dict: APIDict, key: String, dateFormat: String) -> NSDate? {
    let result: AnyObject? = dict[key]
    if let strResult = result as? String {
        let df: NSDateFormatter = NSDateFormatter()
        df.dateFormat = dateFormat
        return df.dateFromString(strResult)
    }

    return nil
}

//Initializers
func apiInstantiateArrayOfApiClasses<T: ApiGeneralObjectProtocol>(initClass: T.Type, array: [AnyObject]?) -> [T]? {

    var arrResult : [T]? = nil

    if let uwArray = array {
        if uwArray.isEmpty {
            return []
        }

        for oneObject in uwArray {
            if let dictObject = oneObject as? APIDict {

                if let oneApiObject: T = apiInstantiateApiClass(initClass, dict: dictObject) {
                    if arrResult == nil {
                        arrResult = [T]()
                    }

                    arrResult?.append(oneApiObject)
                } else {
                    log("failed to instantiate \(T.self) from \(dictObject)")
                }

            }
        }
    }


    return arrResult
}

func apiInstantiateApiClass<T: ApiGeneralObjectProtocol>(T: T.Type, dict: AnyObject?) -> T? {
    if let uwDict: AnyObject = dict {
        let result = T.init(apiDict: uwDict)
        return result
    } else {
        return nil
    }
}

// MARK: API Methods Parsers

/*
    Api Methods Parsers
    - here are constant closures which are used to parse default methods when needed
    - these closures are supplied to ApiMethods during their initialization
*/
let parsePodcastFeed: Parser = { (responseObject: AnyObject?) in
    if let json = responseObject as? APIDict {
        if let items = json["items"] as? [AnyObject] {
            let result = apiInstantiateArrayOfApiClasses(Transaction.self, array: items)
            return ParseResponse(object: result, info: nil)
        }
    }

    return ParseResponse(object: nil, info: nil)
}