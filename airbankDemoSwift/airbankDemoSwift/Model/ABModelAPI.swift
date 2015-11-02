//
//  ABModelAPI.swift
//  airbankDemoSwift
//
//  Created by Premysl Semerad on 02/11/15.
//  Copyright © 2015 Premysl Semerad. All rights reserved.
//

import Foundation
import Alamofire

// MARK: Constants

let kAPIBaseURL = "http://demo0569565.mockable.io/"

// MARK: General Enums & Structs

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

    func requestTypeForDefaultsMethod() -> Alamofire.Method {
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
    var requestType: Alamofire.Method
    var responseType: ApiResponseType

    init(url: String, requestType: Alamofire.Method, responseType: ApiResponseType) {
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

    var requestType: Alamofire.Method {
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

// MARK: Api Calls & API Singleton

public class ABModelAPI {

    static let sharedInstance = ABModelAPI()

    public init() {

    }

    func call(method: ApiMethod, success: (response: ParseResponse) -> Void, failure: (error: NSError?) -> Void) {

        if logRequests {
            log("\(method.description)")
        }

        // TODO: Can't change request type (Method type is ambiguous), or some better response serialization
        if method.responseType == .XML {
            fatalError("XML response not done")
        } else if method.responseType == .JSON {
            Alamofire
                .request(method.requestType, method.urlWithParameters)
                .validate(statusCode: 200..<300)
                .responseJSON(completionHandler: {response in
                    if response.result.isFailure {
                        //ERROR
                        if logErrorResponses {
                            log("ERROR API REQUEST\n \(method.description)\n ERROR: \(response.result.error)")
                        }
                        failure(error: response.result.error)
                    } else {
                        // SUCCESS
                        if logSuccessResponses {
                            log("SUCCESS \(method.description)")
                        }

                        if let parser = method.parser {
                            // PARSE FROM ApiMethod
                            let parseResult = parser(responseObject: response.result.value)
                            success(response: parseResult)
                        } else {
                            // NO PARSING PROVIDED FROM ApiMethod
                            let emptyParseResult = ParseResponse(object: nil, info: nil)
                            success(response: emptyParseResult)
                        }
                    }
                })
        }
    }
}