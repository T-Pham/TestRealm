//
//  Question.swift
//  TestRealm
//
//  Created by Thanh Pham on 7/15/16.
//  Copyright © 2016 Thanh Pham. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper
import AlamofireObjectMapper
import SugarRecord

final class Question: DBObject, Queryable {

    dynamic var content = ""

    override func mapping(map: Map) {
        super.mapping(map)
        content <- map["content"]
    }
}

// MARK: - query
extension Question {
    class func longestQuestion() -> Question? {
        let questions = self.all()
        var longestQuestion: Question? = nil
        for question in questions {
            if (longestQuestion == nil || question.content.characters.count > longestQuestion?.content.characters.count) {
                longestQuestion = question
            }
        }
        return longestQuestion
    }
}

// MARK: - api
extension Question {

    class func fetchSome(completion: ([Question] -> Void)? = nil) {
        let parameters: [String: AnyObject] = [
            "format": "json",
            "page": 1,
            "per_page": 5,
            "user_token": userToken
        ]
        Alamofire.request(.GET, "https://staging.ring.md/api/v4.2/questions", parameters: parameters).responseArray { (response: Response<[Question], NSError>) in
            let questions = response.result.value!
            try! db.operation { (context, save) throws -> Void in
                for question in questions {
                    try! context.insertOrUpdate(question)
                }
                save()

                completion?(questions)
            }
        }
    }
}
