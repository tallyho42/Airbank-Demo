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
    case TransactionDetail

    func parserForDefaultsMethod() -> Parser? {
        switch self {
        case .TransactionsList:
            return parseTransactionList
        case .TransactionDetail:
            return parseTransactionDetail
        }
    }

    func requestTypeForDefaultsMethod() -> Alamofire.Method {
        switch self {
        case .TransactionsList:
            return .GET
        case .TransactionDetail:
            return .GET
        }
    }

    func responseTypeForDefaultsMethod() -> ApiResponseType {
        switch self {
        case .TransactionsList:
            return .JSON
        case .TransactionDetail:
            return .JSON
        }
    }

    func urlForDefaultsMethod() -> String? {
        switch self {
        case .TransactionsList:
            return kAPIBaseURL + "transactions"
        case .TransactionDetail:
            return kAPIBaseURL + "transactions"
        }
    }
}


/*
    Struct used to hold basic information about request - req/response type and url
*/
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

/*
    Generalized response from API - always have some object (array, class, etc.) and sometimes info (i.e. pagination)
*/
public struct ParseResponse {
    let object: AnyObject?
    let info: AnyObject?

    init(object: AnyObject?, info: AnyObject?) {
        self.object = object
        self.info = info
    }
}

/*
    Helper struct for serializing Api Parameters
*/
public struct ApiParameter {
    let key: String
    let value: AnyObject

    init(key: String, value: AnyObject) {
        self.key = key
        self.value = value
    }
}

/*
    Struct that contains all the information about Api Method/Api Call
    - type is a struct containing info about request/response type (for example GET/JSON etc.) and url
    - parameters are additional parameters which will be added to request (as a body to POST and as URL params to a GET request)
    - parser is a closure responsible for parsing succesfull requests. It's usually defined as a constant in ABModelAPIParser class
*/
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
        if let parameters = self.parameters, let url = NSURL(string: self.url) {
            var resultURL = url
            for parameter in parameters {
                resultURL = resultURL.URLByAppendingPathComponent("\(parameter.value)")
            }
            return resultURL.absoluteString
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

/*
    Main singleton for performing all the requests
    - can define request policy (security, chaining, concurrency etc).
    - perform/validates requests
*/
public class ABModelAPI {

    static let sharedInstance = ABModelAPI()

    public init() {
        // Setup security protocols for whole app, possibly add other settings (beware of app transport security)
        _ = ServerTrustPolicy.PinCertificates(
            certificates: ServerTrustPolicy.certificatesInBundle(),
            validateCertificateChain: true,
            validateHost: true
        )
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
                            // NO PARSING PROVIDED FROM ApiMethod -> return nothing
                            let emptyParseResult = ParseResponse(object: nil, info: nil)
                            success(response: emptyParseResult)
                        }
                    }
                })
        }
    }
}