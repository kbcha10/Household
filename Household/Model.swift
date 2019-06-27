//
//  Model.swift
//  Household
//
//  Created by 林香穂 on 2019/06/27.
//  Copyright © 2019 林香穂. All rights reserved.
//

import Foundation
import RealmSwift

class CountModel: Object{
    @objc dynamic var id = 0
    @objc dynamic var today: String = ""
    @objc dynamic var count = 0
    @objc dynamic var memo: String = ""
    @objc dynamic var balance: Bool = true
}
