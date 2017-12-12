//
//  Interceptor.swift
//  ToDoDocker
//
//  Created by Danillo on 07/12/2017.
//  Copyright © 2017 Danillo. All rights reserved.
//

import Foundation
import Genome
import Alamofire
import EasyRest

open class UrlInterceptor: Interceptor {
    
    required public init() {}
    
    open func requestInterceptor<T: NodeInitializable>(_ api: API<T>) {
        let token = UserDefaults.standard.string(forKey: AppConfig.token) as! String
        api.headers["Content-Type"] = "application/json"
        api.headers["Accept"] = "application/json"
        api.headers["Accept-Language"] = "pt-br"
        api.headers["Authorization"] = "Bearer \(token)"
    }
    
    open func responseInterceptor<T>(_ api: API<T>, response: DataResponse<Any>) where T : NodeInitializable {
        
    }
}

