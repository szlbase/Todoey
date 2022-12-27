//
//  ColoredObjects.swift
//  Todoey
//
//  Created by LIN SHI ZHENG on 22/12/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class ColoredObjects: Object {
    @Persisted var backgroundColor: String?
}
