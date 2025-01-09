//
//  TodoRepository.swift
//  Todo
//
//  Created by Мурад on 5/1/25.
//

import Foundation
import CoreData

class TodoRepository: ObservableObject {
    @Published var todos: [TodoItem] = []
    private let url = "https://dummyjson.com/todos"
    
    func fetch(context: NSManagedObjectContext) {
        guard let url = URL(string: url) else { fatalError("Missing URL") }
        
        let urlRequest = URLRequest(url: url)
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            if let error = error {
                print("Request error:", error)
                return
            }
            
            guard let response = response  as? HTTPURLResponse else { return }
            
            if response.statusCode == 200 {
                guard let data = data else { return }
            
            DispatchQueue.main.async {
                do {
                    
                    let decodedTodo = try JSONDecoder().decode(TodoModel.self, from: data)
                    self.todos = decodedTodo.todos
                    saveTodosCoreData(decodedTodo.todos)
                } catch let error {
                    print("Error decoding: ", error)
                }
            }}
        }
        
        dataTask.resume()
    }
}
