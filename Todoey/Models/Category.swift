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
    @objc dynamic var color: String = "#A38570"
    let items = List<Item>()
}
