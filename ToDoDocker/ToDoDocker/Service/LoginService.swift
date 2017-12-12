//
//  PostService.swift
//  ToDoDocker
//
//  Created by Danillo on 06/12/2017.
//  Copyright © 2017 Danillo. All rights reserved.
//

import Foundation
import EasyRest


class LoginService: Service<LoginRoute> {
    
    override var base: String { return AppConfig.kHttpEndpoint }
    
    func getLogin( username: String, password: String,
        onSuccess: @escaping (Response<Login>?) -> Void,
                  onError: @escaping (RestError?) -> Void,
                  always: @escaping () -> Void) {
        try! call(.getLogin(username: username, password: password), type: Login.self, onSuccess: onSuccess,
                  onError: onError, always: always)
    }
    
}
