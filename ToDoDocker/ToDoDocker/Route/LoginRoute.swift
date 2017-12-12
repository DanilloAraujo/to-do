//
//  PostRoute.swift
//  ToDoDocker
//
//  Created by Danillo on 06/12/2017.
//  Copyright © 2017 Danillo. All rights reserved.
//

import Foundation
import EasyRest


enum LoginRoute: Routable {
    
    case getLogin(username: String, password: String)
    
    var rule: Rule {
        switch self {
        case let .getLogin(username, password):
            return Rule(method: .post, path: "oauth/token/",
                        isAuthenticable: false, parameters: [.query: [
                "client_id": AppConfig.client_id,
                "client_secret": AppConfig.cliente_secret,
                "username": username,
                "password": password,
                "grant_type": "password"
                ]
                ])
        }
    }
    
}
