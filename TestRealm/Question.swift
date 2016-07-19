//
//  Question.swift
//  TestRealm
//
//  Created by Thanh Pham on 7/15/16.
//  Copyright © 2016 Thanh Pham. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper
import Alamofire
import AlamofireObjectMapper

final class Question: DBObject, Queryable {

    dynamic var content: String? = nil
    dynamic var updateAt: NSDate = NSDate()
    var answers = List<Answer>()

    override func mapping(map: Map) {
        super.mapping(map)
        content <- map["content"]
        updateAt <- map["update_at"]
        answers <- (map["answers"], ListTransform<Answer>())
    }
}

// MARK: - query
extension Question {

    class func longestQuestion() -> Question? {
        let questions = self.all()
        var longestQuestion: Question? = nil
        for question in questions {
            if longestQuestion == nil || question.content?.characters.count > longestQuestion?.content?.characters.count {
                longestQuestion = question
            }
        }
        return longestQuestion
    }
}

// MARK: - api
extension Question {

    class func fetchSome(completion: ([Question]? -> Void)? = nil) {
        let parameters: [String: AnyObject] = [
            "format": "json",
            "page": 1,
            "per_page": 5,
            "user_token": Requester.userToken!
        ]
        Alamofire.request(.GET, "https://staging.ring.md/api/v4.2/questions/mine", parameters: parameters).responseArray { (response: Response<[Question], NSError>) in
            switch response.result {
            case .Success(let value):
                let questions = value
                DB.update {
                    DB.realm.add(questions, update: true)
                }
                completion?(questions)
            case .Failure(let error):
                print(error)
                completion?(nil)
            }
        }
    }

    func fetchAnswers(completionHandler: (RequesterResponse<Question> -> Void)? = nil) {
        Requester.request(.GET, "https://staging.ring.md/api/v4.2/questions/\(id)/answers", completionHandler: completionHandler)
    }
}
