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
