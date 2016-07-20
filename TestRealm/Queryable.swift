//
//  Queryable.swift
//  TestRealm
//
//  Created by Thanh Pham on 7/18/16.
//  Copyright © 2016 Thanh Pham. All rights reserved.
//

import Foundation
import RealmSwift

protocol Queryable {
    static func all() -> List<ActualClass>
    static func findByPrimaryKey(value: AnyObject) -> ActualClass?
}

extension Queryable where Self: Object {

    typealias ActualClass = Self

    static func all() -> List<ActualClass> {
        return List(DB.realm.objects(ActualClass))
    }

    static func findByPrimaryKey(value: AnyObject) -> ActualClass? {
        let primaryKey = ActualClass.primaryKey()
        guard primaryKey != nil else {
            return nil
        }
        return DB.realm.objects(ActualClass).filter("%K == %@", primaryKey!, value).first
    }
}
