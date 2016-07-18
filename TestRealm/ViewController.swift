//
//  ViewController.swift
//  TestRealm
//
//  Created by Thanh Pham on 7/15/16.
//  Copyright © 2016 Thanh Pham. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

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
            userToken = (response.result.value as! NSDictionary)["authentication_token"] as! String
            self?.test()
        }
    }

    func test() {
        Question.fetchSome { questions in
            let question = Question.longestQuestion()!
            updateDb {
                question.content = "I can modify a record"
            }
            print(Question.findById(question.id))
            print(Question.all())
        }
    }
}
