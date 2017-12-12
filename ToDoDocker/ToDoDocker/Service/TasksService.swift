//
//  TasksService.swift
//  ToDoDocker
//
//  Created by Danillo on 07/12/2017.
//  Copyright © 2017 Danillo. All rights reserved.
//

import Foundation
import EasyRest

class TasksService: Service<TasksRoute> {
    
    override var base: String { return AppConfig.kHttpEndpoint }
    
    override var interceptors: [Interceptor]? {return [UrlInterceptor()]}
    
    func getTasks(
        onSuccess: @escaping (Response<Tasks>?) -> Void,
        onError: @escaping (RestError?) -> Void,
        always: @escaping () -> Void) {
        try! call(.getTasks, type: Tasks.self, onSuccess: onSuccess,
                  onError: onError, always: always)
    }
    
    func saveTask(task: Result,
        onSuccess: @escaping (Response<Result>?) -> Void,
        onError: @escaping (RestError?) -> Void,
        always: @escaping () -> Void) {
        try! call(.saveTask(task: task), type: Result.self, onSuccess: onSuccess,
                  onError: onError, always: always)
    }
    
    func editTask(task: Result,
                  onSuccess: @escaping (Response<Result>?) -> Void,
                  onError: @escaping (RestError?) -> Void,
                  always: @escaping () -> Void) {
        try! call(.editTask(task: task), type: Result.self, onSuccess: onSuccess,
                  onError: onError, always: always)
    }
    
    func delete(task: Result,
                onSuccess: @escaping (Response<Result>?) -> Void,
                onError: @escaping (RestError?) -> Void,
                always: @escaping () -> Void) {
        try! call(.delete(task: task), type: Result.self, onSuccess: onSuccess,
                  onError: onError, always: always)
    }
}
