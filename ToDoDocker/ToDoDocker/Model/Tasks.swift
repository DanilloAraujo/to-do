//
//  Tasks.swift
//  ToDoDocker
//
//  Created by Danillo on 07/12/2017.
//  Copyright © 2017 Danillo. All rights reserved.
//

import Foundation
import EasyRest
import Genome

class Tasks: BaseModel {
    var count: Int?
    var next: String?
    var previous: String?
    var results: [Result]?
    
    override func sequence(_ map: Map) throws {
        try count <~> map["count"]
        try next <~> map["next"]
        try previous <~> map["previous"]
        try results <~> map["results"]
    }
}

class Result: BaseModel {
    var id: String?
    var expirationDate: String?
    var title: String?
    var desc: String?
    var isComplete: Bool?
    var owner: String?
    
    override func sequence(_ map: Map) throws {
        try id <~> map["id"]
        try expirationDate <~> map["expiration_date"]
        try title <~> map["title"]
        try desc <~> map["description"]
        try isComplete <~> map["is_complete"]
        try owner <~> map["owner"]
    }
}
