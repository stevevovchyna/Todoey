//
//  Item.swift
//  Todoey
//
//  Created by Steve Vovchyna on 08.11.2019.
//  Copyright © 2019 Steve Vovchyna. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date = Date()
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
