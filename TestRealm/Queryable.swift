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
}

extension Queryable where Self: DBObject {

    typealias ActualClass = Self

    static func all() -> [ActualClass] {
        return try! db.fetch(SugarRecord.Request<ActualClass>())
    }

    func update(updateBlock: ActualClass -> ()) {
        try! db.operation({ (context, save) -> Void in
            updateBlock(self)
            save()
        })
    }
}
