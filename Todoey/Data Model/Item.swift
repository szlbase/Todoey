//
//  Item.swift
//  Todoey
//
//  Created by LIN SHI ZHENG on 21/12/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @Persisted var title: String = ""
    @Persisted var done: Bool = false
    @Persisted var dateCreated = Date()
    
    @Persisted(originProperty: "items") var parentCategory : LinkingObjects<Category>
    
//        If using @objc dynamic
//    @objc dynamic var title: String = ""
//    @objc dynamic var done: Bool = false
//    
//    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
