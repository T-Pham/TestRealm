//
//  ListTransform.swift
//  TestRealm
//
//  Created by Thanh Pham on 7/18/16.
//  Copyright © 2016 Thanh Pham. All rights reserved.
//

import Foundation
import ObjectMapper
import RealmSwift

class ListTransform<T: Object where T: Mappable>: TransformType {
    typealias Object = List<T>
    typealias JSON = [AnyObject]

    let mapper = Mapper<T>()

    func transformFromJSON(value: AnyObject?) -> Object? {
        let results = Object()
        if let value = value as? JSON {
            for json in value {
                if let object = mapper.map(json) {
                    results.append(object)
                }
            }
        }
        return results
    }

    func transformToJSON(value: Object?) -> JSON? {
        var results = JSON()
        if let value = value {
            for object in value {
                let json = mapper.toJSON(object)
                results.append(json)
            }
        }
        return results
    }
}
