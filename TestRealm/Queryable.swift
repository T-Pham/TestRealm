//
//  Queryable.swift
//  TestRealm
//
//  Created by Thanh Pham on 7/18/16.
//  Copyright © 2016 Thanh Pham. All rights reserved.
//

import Foundation
import SugarRecord

protocol Queryable {
    static func all() -> [Self]
    static func findById(id: Int) -> ActualClass?
    func update(updateBlock: ActualClass -> ())
}

extension Queryable where Self: DBObject {

    typealias ActualClass = Self

    static func all() -> [ActualClass] {
        return try! db.fetch(SugarRecord.Request<ActualClass>())
    }

    static func findById(id: Int) -> ActualClass? {
        let predicate = NSPredicate(format: "id == %d", id)
        return try! db.fetch(Request<ActualClass>().filteredWith(predicate: predicate)).first
    }

    func update(updateBlock: ActualClass -> ()) {
        try! db.operation({ (context, save) -> Void in
            updateBlock(self)
            save()
        })
    }
}
