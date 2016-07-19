//
//  DB.swift
//  TestRealm
//
//  Created by Thanh Pham on 7/18/16.
//  Copyright © 2016 Thanh Pham. All rights reserved.
//

import Foundation
import RealmSwift

struct DB {
    static let realm = try! Realm()

    static func update(@noescape updateBlock: () -> ()) {
        realm.beginWrite()
        updateBlock()
        try! realm.commitWrite()
    }

    static func migrate() {
        var configuration = Realm.Configuration.defaultConfiguration
        configuration.schemaVersion = 3
        configuration.migrationBlock = { migration, oldSchemeVersion in
        }
        Realm.Configuration.defaultConfiguration = configuration
    }
}
