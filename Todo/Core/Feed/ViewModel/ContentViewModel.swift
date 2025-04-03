//
//  ContentViewModel.swift
//  Todo
//
//  Created by Мурад on 3/4/25.
//

import Foundation
import SwiftUI
import CoreData

class ContentViewModel: ObservableObject {
    @Published var todoText: String = ""
    @Published var todoDescription: String = ""
    @Published var filter: FilterOption = .all
    @Published var activeSheet: ActiveSheet?
    @Published var todoUid: NSManagedObjectID?
    @Published var viewContext = PersistenceController.shared.context

    func fetchTodo() {
        TodoRepository.shared.fetch(context: viewContext)
    }
    
    func deleteTodo () {
        let object = viewContext.object(with: todoUid!)
        viewContext.delete(object)
        
        saveContext()
    }
    
    func updateTodo() {
        let object = viewContext.object(with: todoUid!)
        if let todo = object as? Task {
            todo.todo = todoText
            todo.userId = todoDescription
        }
        saveContext()
    }
    
    func addTodo() {
        withAnimation {
            let newTodo = Task(context: viewContext)
            newTodo.userId = todoDescription
            newTodo.todo = todoText
            newTodo.createdAt = Date()
            newTodo.completed = false
        }
        saveContext()
    }
    
    /// Функция для сохранения контекста Core Data
    func saveContext() {
        do {
            try viewContext.save()
//            fetchItems()
            print("Changes saved successfully.")
        } catch {
            print("Error saving context: \(error)")
        }
    }
}
