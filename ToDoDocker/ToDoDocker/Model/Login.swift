//
//  Post.swift
//  ToDoDocker
//
//  Created by Danillo on 06/12/2017.
//  Copyright © 2017 Danillo. All rights reserved.
//

import Foundation
import EasyRest
import Genome


class Login: BaseModel {
    var token: String?
    var expires: Int?
    var refreshToken: String?
    var tokenType: String?
    
    override func sequence(_ map: Map) throws {
        try token <~> map["access_token"]
        try expires <~> map["expires_in"]
        try refreshToken <~> map["refresh_token"]
        try tokenType <~> map["token_type"]
    }
    
}

var loginModel = Login()
