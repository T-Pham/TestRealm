//
//  Requester.swift
//  TestRealm
//
//  Created by Thanh Pham on 7/19/16.
//  Copyright © 2016 Thanh Pham. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper

enum RequesterResponse<Value> {
    case Success(Value)
    case Failure(NSError?, AnyObject?)
}

struct Requester {

    struct Options {
        var appendDefaultParameters = true
        var saveObjectsToDB = true

        init(appendDefaultParameters shouldAppendDefaultParameters: Bool = true, saveObjectsToDB shouldSaveObjectsToDB: Bool = true) {
            appendDefaultParameters = shouldAppendDefaultParameters
            saveObjectsToDB = shouldSaveObjectsToDB
        }
    }

    static var userToken: String?

    static func signIn(completionHandler: (RequesterResponse<AnyObject> -> Void)? = nil) {
        let parameters = [
            "device": [
                "app_version": "2.6.1",
                "type": "IosDevice",
                "name": "iPhone Simulator",
                "device_token": "c920903a4555daecde37a0111ee8e38581c2ea7c0ff2ca69ea020c683c5ac5b9"
            ],
            "format": "json",
            "user": [
                "login": "thanh+patient@ring.md",
                "password": "password"
            ]
        ]
        request(.POST, "https://staging.ring.md/api/v5/public/tokens", parameters: parameters, options: Options(appendDefaultParameters: false)) { response in
            if case .Success(let json) = response, let userToken = json["authentication_token"] as? String {
                Requester.userToken = userToken
            }
            completionHandler?(response)
        }
    }

    static func request<Type: Mappable>(method: Alamofire.Method, _ urlString: URLStringConvertible, parameters: [String: AnyObject]? = nil, options: Options = Options(), completionHandler: (RequesterResponse<Type> -> Void)? = nil) {
        alamofireRequest(method, urlString, parameters: parameters, options: options).responseObject { (response: Response<Type, NSError>) in
            handleResponse(response) { innerReponse in
                if case .Success(let object) = innerReponse, let dbObject = object as? DBObject where options.saveObjectsToDB {
                    DB.update {
                        DB.realm.add(dbObject, update: true)
                    }
                }
                completionHandler?(innerReponse)
            }
        }
    }

    static func request(method: Alamofire.Method, _ urlString: URLStringConvertible, parameters: [String: AnyObject]? = nil, options: Options = Options(), completionHandler: (RequesterResponse<AnyObject> -> Void)? = nil) {
        alamofireRequest(method, urlString, parameters: parameters, options: options).responseJSON { response in
            handleResponse(response, completionHandler: completionHandler)
        }
    }

    static private func alamofireRequest(method: Alamofire.Method, _ urlString: URLStringConvertible, parameters: [String: AnyObject]? = nil, options: Options = Options()) -> Request {
        if (options.appendDefaultParameters) {
            var parameters = parameters ?? [String: AnyObject]()
            parameters["format"] = "json"
            parameters["user_token"] = userToken
        }
        return Alamofire.request(method, urlString, parameters: parameters)
    }

    static private func handleResponse<T>(response: Response<T, NSError>, completionHandler: (RequesterResponse<T> -> Void)? = nil) {
        if case .Success = response.result where response.response?.statusCode == 200 {
            completionHandler?(.Success(response.result.value!))
        } else {
            guard let completionHandler = completionHandler else {
                return
            }

            var error: NSError?
            if case .Failure(let e) = response.result {
                error = e
            }
            var json: AnyObject?
            if let data = response.data {
                json = try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
            }
            completionHandler(.Failure(error, json))
        }
    }
}
