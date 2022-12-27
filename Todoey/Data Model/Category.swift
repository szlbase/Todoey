//
//  Category.swift
//  Todoey
//
//  Created by LIN SHI ZHENG on 21/12/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: ColoredObjects {
    @Persisted var name: String = ""
    @Persisted var items: List<Item>
    
//    If using @objc dynamic
//    var items = List<Item>()
}
