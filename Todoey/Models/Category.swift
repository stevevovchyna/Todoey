//
//  Category.swift
//  Todoey
//
//  Created by Steve Vovchyna on 08.11.2019.
//  Copyright © 2019 Steve Vovchyna. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
