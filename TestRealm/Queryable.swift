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
    static func all() -> [Self]
    static func findById(id: Int) -> ActualClass?
}

extension Queryable where Self: DBObject {

    typealias ActualClass = Self

    static func all() -> [ActualClass] {
        return Array(db.objects(ActualClass))
    }

    static func findById(id: Int) -> ActualClass? {
        return db.objects(ActualClass).filter("id == \(id)").first
    }
}
