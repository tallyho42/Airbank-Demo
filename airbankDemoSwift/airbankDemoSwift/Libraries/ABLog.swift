//
//  ABLog.swift
//  airbankDemoSwift
//
//  Created by Premysl Semerad on 02/11/15.
//  Copyright © 2015 Premysl Semerad. All rights reserved.
//

import Foundation

func log(@autoclosure message: () -> String, filename: String = __FILE__, functionName: String = __FUNCTION__, line: Int = __LINE__) {
    let df = NSDateFormatter()
    df.dateFormat = "HH:mm:ss:SSS"

    let dateString = df.stringFromDate(NSDate())
    let fileName = ((filename as NSString).lastPathComponent as NSString).stringByDeletingPathExtension

    print("【\(dateString) \(fileName) \(functionName):\(line)】\(message())")
}