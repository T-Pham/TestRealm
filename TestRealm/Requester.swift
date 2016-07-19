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

typealias JSON = [String: AnyObject]

enum Response<Value> {
    case Success(Value)
    case Failure(NSError?, JSON?)
}

struct Requester {

    static var userToken: String?

    static func signIn(completionHandler: (Response<JSON> -> Void)? = nil) {
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
        Alamofire.request(.POST, "https://staging.ring.md/api/v5/public/tokens", parameters: parameters).responseJSON { response in
            switch response.result {
            case .Success(let value):
                guard let json = value as? [String: AnyObject], userToken = json["authentication_token"] as? String else {
                    completionHandler?(.Failure(nil, nil))
                    return
                }
                Requester.userToken = userToken
                completionHandler?(.Success(json))
            case .Failure(let error):
                completionHandler?(.Failure(error, nil))
            }
        }
    }

    static func request<Type: DBObject>(method: Alamofire.Method, _ urlString: URLStringConvertible, parameters: [String: AnyObject]? = nil, completionHandler: (Response<Type> -> Void)? = nil) {
        var parameters = parameters ?? [String: AnyObject]()
        parameters["format"] = "json"
        parameters["user_token"] = userToken
        Alamofire.request(method, urlString, parameters: parameters).responseObject { (response: Alamofire.Response<Type, NSError>) in
            guard response.response?.statusCode == 200 else {
                guard let completionHandler = completionHandler else {
                    return
                }
                var json: JSON?
                if let data = response.data {
                    json = (try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)) as? JSON
                }
                completionHandler(.Failure(nil, json))
                return
            }
            switch response.result {
            case .Success(let value):
                updateDb {
                    db.add(value, update: true)
                }
                completionHandler?(.Success(value))
            case .Failure(let error):
                completionHandler?(.Failure(error, nil))
            }
        }
    }
}
