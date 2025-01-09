//
//  TodoModel.swift
//  Todo
//
//  Created by Мурад on 5/1/25.
//

import Foundation

struct TodoModel: Codable {
    let todos: [TodoItem]
    let total, skip, limit: Int
}

struct TodoItem: Codable, Hashable {
    let id: Int
    let todo: String
    var completed: Bool
    let userId: Int
    
    enum CodingKeys: String, CodingKey {
        case id, todo, completed
        case userId = "userId"
    }
}
