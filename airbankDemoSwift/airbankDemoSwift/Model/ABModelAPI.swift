//
//  ABModelAPI.swift
//  airbankDemoSwift
//
//  Created by Premysl Semerad on 02/11/15.
//  Copyright © 2015 Premysl Semerad. All rights reserved.
//

import Foundation

// MARK: Constants

let kAPIBaseURL = "http://demo0569565.mockable.io/"

// MARK: General Enums & Structs

enum ApiRequestType: String {
    case GET = "GET"
    case POST = "POST"
}

enum ApiResponseType {
    case JSON
    case XML
}

/*
    Defaults:
    - API methods can be easily managed just by changing this ENUM
    - add new case for every new API Call and then add corresponding cases to switches in functions
*/
enum ApiMethodDefaults {
    case TransactionsList

    func parserForDefaultsMethod() -> Parser? {
        switch self {
        case .TransactionsList:
            return parsePodcastFeed
        }
    }

    func requestTypeForDefaultsMethod() -> ApiRequestType {
        switch self {
        case .TransactionsList:
            return .GET
        }
    }

    func responseTypeForDefaultsMethod() -> ApiResponseType {
        switch self {
        case .TransactionsList:
            return .JSON
        }
    }

    func urlForDefaultsMethod() -> String? {
        switch self {
        case .TransactionsList:
            return kAPIBaseURL + "transactions"
        }
    }
}

struct ApiMethodType {

    var url: String
    var requestType: ApiRequestType
    var responseType: ApiResponseType

    init(url: String, requestType: ApiRequestType, responseType: ApiResponseType) {
        self.url = url
        self.requestType = requestType
        self.responseType = responseType
    }

    init(defaults: ApiMethodDefaults) {
        if let url = defaults.urlForDefaultsMethod() {
            self.url = url
        } else {
            self.url = kAPIBaseURL
        }
        self.requestType = defaults.requestTypeForDefaultsMethod()
        self.responseType = defaults.responseTypeForDefaultsMethod()
    }
}

public struct ParseResponse {
    let object: AnyObject?
    let info: AnyObject?

    init(object: AnyObject?, info: AnyObject?) {
        self.object = object
        self.info = info
    }
}

public struct ApiParameter {
    let key: String
    let value: AnyObject
}

public struct ApiMethod {

    let type: ApiMethodType
    let parameters: [ApiParameter]?
    let parser: Parser?

    var alamoParameters: [String:AnyObject]? {
        if let parameters = parameters {
            var params = [String:AnyObject]()
            for oneParameter in parameters {
                params[oneParameter.key] = oneParameter.value
            }
            return params
        } else {
            return nil
        }
    }

    var url: String {
        return self.type.url
    }

    var requestType: ApiRequestType {
        return self.type.requestType
    }

    var responseType: ApiResponseType {
        return self.type.responseType
    }

    var urlWithParameters: String {
        if let parameters = self.parameters {
            var urlString = self.url
            var sep = urlString.containsString("?") ? "&" : "?"
            
            for parameter in parameters {
                if let encodedKey = parameter.key.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding),
                    let encodedValue = "\(parameter.value)".stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding) {
                        urlString += "\(sep)\(encodedKey)=\(encodedValue)"
                        sep = "&"
                }
            }
            return urlString
        } else {
            return self.url
        }
    }

    var description: String {
        if requestType == .GET {
            return("API REQUEST (\(self.requestType.rawValue)), full url: \(self.urlWithParameters)")
        } else {
            return("API REQUEST (\(self.requestType.rawValue)), url: \(self.url), parameters: \(self.alamoParameters)")
        }
    }

    // MARK: Initializers

    init(type: ApiMethodType, url: String? = nil, parameters: [ApiParameter]? = nil, parser: Parser? = nil) {
        self.type = type
        self.parameters = parameters
        self.parser = nil
    }

    init(defaults: ApiMethodDefaults, parameters: [ApiParameter]? = nil) {
        self.type = ApiMethodType(defaults: defaults)
        self.parameters = parameters
        self.parser = defaults.parserForDefaultsMethod()
    }
}