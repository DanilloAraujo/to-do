//
//  ResultDB.swift
//  ToDoDocker
//
//  Created by Danillo on 11/12/2017.
//  Copyright © 2017 Danillo. All rights reserved.
//

import Foundation
import RealmSwift

class ResultDB: Object {
    
    @objc dynamic var id = NSUUID().uuidString
    @objc dynamic var title: String?
    @objc dynamic var desc: String?
    @objc dynamic var expirationDate: String?
    @objc dynamic var isComplete: Bool = false
    @objc dynamic var isEnviado: Bool = false
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
