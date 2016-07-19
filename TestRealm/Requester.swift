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

    struct Options: OptionSetType {
        let rawValue: Int

        static let None = Options(rawValue: 0)

        static let AppendDefaultParameters = Options(rawValue: 1 << 0)
        static let SaveObjectsToDB = Options(rawValue: 1 << 1)

        static let Default = Options(rawValue: AppendDefaultParameters.rawValue | SaveObjectsToDB.rawValue)
        static let DisableAppendDefaultParameters = Options(rawValue: Default.rawValue & (~AppendDefaultParameters.rawValue))
        static let DisableSaveObjectsToDB = Options(rawValue: Default.rawValue & (~SaveObjectsToDB.rawValue))
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
        request(.POST, URLConstants.apiv5Path + "public/tokens", parameters: parameters, options: .DisableAppendDefaultParameters) { response in
            if case .Success(let json) = response, let userToken = json["authentication_token"] as? String {
                Requester.userToken = userToken
            }
            completionHandler?(response)
        }
    }

    static func request(method: Alamofire.Method, _ path: String, parameters: [String: AnyObject]? = nil, options: Options = .Default, completionHandler: (RequesterResponse<AnyObject> -> Void)? = nil) {
        alamofireRequest(method, path, parameters: parameters, options: options).responseJSON { response in
            handleResponse(response, options: options, completionHandler: completionHandler)
        }
    }

    static func request<Type: Mappable>(method: Alamofire.Method, _ path: String, parameters: [String: AnyObject]? = nil, options: Options = .Default, completionHandler: (RequesterResponse<Type> -> Void)? = nil) {
        alamofireRequest(method, path, parameters: parameters, options: options).responseObject { (response: Response<Type, NSError>) in
            handleResponse(response, options: options, completionHandler: completionHandler)
        }
    }

    static private func alamofireRequest(method: Alamofire.Method, _ path: String, parameters: [String: AnyObject]?, options: Options) -> Request {
        let shouldAppendDefaultParameters = options.contains(.AppendDefaultParameters)
        var parameters = parameters ?? (shouldAppendDefaultParameters ? [String: AnyObject]() : nil)
        if shouldAppendDefaultParameters {
            parameters?["format"] = "json"
            parameters?["user_token"] = userToken
        }
        let url = NSURL(string: path, relativeToURL: NSURL(string: URLConstants.serverURL))!
        return Alamofire.request(method, url, parameters: parameters)
    }

    static private func handleResponse<T>(response: Response<T, NSError>, options: Options, completionHandler: (RequesterResponse<T> -> Void)? = nil) {
        if case .Success(let value) = response.result where response.response?.statusCode == 200 {
            if let dbObject = value as? DBObject where options.contains(.SaveObjectsToDB) {
                DB.update {
                    DB.realm.add(dbObject, update: true)
                }
            }
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
