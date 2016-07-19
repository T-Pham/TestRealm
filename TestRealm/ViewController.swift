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
        Requester.signIn { [weak self] response in
            switch response {
            case .Success:
                self?.test()
            case .Failure(let error, let json):
                print(error)
                print(json)
            }
        }
    }

    func test() {
        Question.fetchSome { response in
            switch response {
            case .Success:
                let question = Question.longestQuestion()!
                question.fetchAnswers { response in
                    switch response {
                    case .Success:
                        let answers = Answer.all()
                        print(answers.map { $0.content })
                        print(answers.map { $0.question })
                    case .Failure(let error, let json):
                        print(error)
                        print(json)
                    }
                }
            case .Failure(let error, let json):
                print(error)
                print(json)
            }
        }
    }
}
