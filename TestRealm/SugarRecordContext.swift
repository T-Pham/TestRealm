//
//  Stuff.swift
//  TestRealm
//
//  Created by Thanh Pham on 7/18/16.
//  Copyright © 2016 Thanh Pham. All rights reserved.
//

import SugarRecord
import RealmSwift

extension Context {
    public func insertOrUpdate<T: Entity>(entity: T) throws {
        guard let _ = T.self as? Object.Type else { throw Error.InvalidType }

        if let realm = self as? Realm {
            realm.add(entity as! Object, update: true)
        } else {
            throw Error.InvalidOperation("-insertOrUpdate not available in contexts other than Realm.")
        }
    }
}
