//
//  Global.swift
//  TestRealm
//
//  Created by Thanh Pham on 7/18/16.
//  Copyright © 2016 Thanh Pham. All rights reserved.
//

import RealmSwift

var userToken = ""
let db = try! Realm()

func updateDb(@noescape updateBlock: () -> ()) {
    db.beginWrite()
    updateBlock()
    try! db.commitWrite()
}
