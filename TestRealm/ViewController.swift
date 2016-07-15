//
//  ViewController.swift
//  TestRealm
//
//  Created by Thanh Pham on 7/15/16.
//  Copyright © 2016 Thanh Pham. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import SugarRecord

class ViewController: UIViewController {

    let db = RealmDefaultStorage()
    var userToken: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        signIn()
    }

    func signIn() {
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
        Alamofire.request(.POST, "https://staging.ring.md/api/v5/public/tokens", parameters: parameters).responseJSON { [weak self] response in
            print("\(response.request?.URL): \(response)")
            self?.userToken = (response.result.value as! NSDictionary)["authentication_token"] as! String
            self?.fetchQuestions()
        }
    }

    func fetchQuestions() {
        let parameters: [String: AnyObject] = [
            "format": "json",
            "page": 1,
            "per_page": 5,
            "user_token": userToken
            ]
        Alamofire.request(.GET, "https://staging.ring.md/api/v4.2/questions", parameters: parameters).responseArray { (response: Response<[Question], NSError>) in
            let questions = response.result.value
            print("Questions: \(questions)")
        }
    }
}
