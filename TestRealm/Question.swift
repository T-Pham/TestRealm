//
//  Question.swift
//  TestRealm
//
//  Created by Thanh Pham on 7/15/16.
//  Copyright © 2016 Thanh Pham. All rights reserved.
//

import Realm
import ObjectMapper

class Question: RLMObject, Mappable {
    var id: Int?
    var content: String?

    required convenience init?(_ map: Map) {
        self.init()
    }

    func mapping(map: Map) {
        id <- map["id"]
        content <- map["content"]
    }
}
