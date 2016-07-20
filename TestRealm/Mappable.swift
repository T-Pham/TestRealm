//
//  Mappable.swift
//  TestRealm
//
//  Created by Thanh Pham on 7/20/16.
//  Copyright © 2016 Thanh Pham. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

extension Mappable where Self: Object {

    init?(_ map: Map) {
        let primaryKey = Self.primaryKey()
        guard primaryKey == nil || map.JSONDictionary[primaryKey!] != nil else {
            return nil
        }
        self.init()
    }
}
