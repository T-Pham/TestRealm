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

    func mapping(map: Map) {
        id <- map["id"]
    }

    override class func primaryKey() -> String {
        return "id"
    }
}

extension Mappable where Self: DBObject {
    init?(_ map: Map) {
        self.init()
    }
}
