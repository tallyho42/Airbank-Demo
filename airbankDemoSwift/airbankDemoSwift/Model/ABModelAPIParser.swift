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

let parsePodcastFeed: Parser = { (responseObject: AnyObject?) in
    /*
    if let document = responseObject as? ONOXMLDocument {

        let result = apiInstantiateApiClass(PodcastFeed.self, dict: document)

        return ParseResponse(object: result, info: nil)
    } else {
        log("ERROR parsing object: \(responseObject)")
        return ParseResponse(object: nil, info: nil)
    }
    */
    return ParseResponse(object: nil, info: nil)
}