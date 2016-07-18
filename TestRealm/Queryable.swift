//
//  Queryable.swift
//  TestRealm
//
//  Created by Thanh Pham on 7/18/16.
//  Copyright © 2016 Thanh Pham. All rights reserved.
//

import RealmSwift

protocol Queryable {
    static func all() -> List<ActualClass>
    static func findById(id: Int) -> ActualClass?
}

extension Queryable where Self: DBObject {

    typealias ActualClass = Self

    static func all() -> List<ActualClass> {
        return List(db.objects(ActualClass))
    }

    static func findById(id: Int) -> ActualClass? {
        return db.objects(ActualClass).filter("id == \(id)").first
    }
}
