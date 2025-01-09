//
//  Persistence.swift
//  Todo
//
//  Created by Мурад on 6/1/25.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "CoreData")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    var context: NSManagedObjectContext {
        return container.viewContext
    }
}

func saveTodosCoreData(_ todos: [TodoItem]) {
    let context = PersistenceController.shared.context
    for todo in todos {
        let newTodo = Task(context: context)
        newTodo.id = Int16(todo.id)
        newTodo.completed = todo.completed
        newTodo.todo = todo.todo
        newTodo.userId = String(todo.userId)
        newTodo.createdAt = Date()
    }
    do {
        try context.save()
        print("Tasks saved to Core Data")
    } catch {
        print("Error saving tasks: \(error)")
    }
}
