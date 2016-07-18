//
//  AppDelegate.swift
//  TestRealm
//
//  Created by Thanh Pham on 7/15/16.
//  Copyright © 2016 Thanh Pham. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        var configuration = Realm.Configuration.defaultConfiguration
        configuration.schemaVersion = 2
        configuration.migrationBlock = { migration, oldSchemeVersion in
            if oldSchemeVersion < 2 {
            }
        }
        Realm.Configuration.defaultConfiguration = configuration
        return true
    }
}
