//
//  Answer.swift
//  TestRealm
//
//  Created by Thanh Pham on 7/18/16.
//  Copyright © 2016 Thanh Pham. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

final class Answer: DBObject, Queryable {

    let questions = LinkingObjects(fromType: Question.self, property: "answers")
    var question: Question? {
        get {
            return questions.first
        }
    }
    dynamic var content = ""

    override func mapping(map: Map) {
        super.mapping(map)
        content <- map["content"]
    }
}
