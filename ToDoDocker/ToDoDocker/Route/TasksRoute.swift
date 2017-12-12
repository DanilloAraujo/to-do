//
//  TasksRoute.swift
//  ToDoDocker
//
//  Created by Danillo on 07/12/2017.
//  Copyright © 2017 Danillo. All rights reserved.
//

import Foundation
import EasyRest

enum TasksRoute: Routable {
    
    case getTasks
    
    case saveTask(task: Result)
    
    case editTask(task: Result)
    
    case delete(task: Result)
    
    var rule: Rule {
        switch self {
        case .getTasks:
            return Rule(method: .get, path: "v1/tasks/",
                        isAuthenticable: false, parameters: [:]
            )
        case let .saveTask(task):
            return Rule(method: .post, path: "v1/tasks/", isAuthenticable: false, parameters: [.body: task])
            
        case let .editTask(task):
            return Rule(method: .put, path: "v1/tasks/\(task.id ?? "")/", isAuthenticable: false, parameters: [.body: task])
            
        case let .delete(task):
            return Rule(method: .delete, path: "v1/tasks/\(task.id ?? "")/", isAuthenticable: false, parameters: [:])
        }
    }
    
}
