//
//  DBObject.swift
//  TestRealm
//
//  Created by Thanh Pham on 7/18/16.
//  Copyright © 2016 Thanh Pham. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class DBObject: Object, Mappable {

    dynamic var id = 0

    override class func primaryKey() -> String {
        return "id"
    }

    func mapping(map: Map) {
        if id == 0 {
            id <- map["id"]
        }
    }
}
