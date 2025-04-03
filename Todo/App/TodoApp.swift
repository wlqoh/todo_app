//
//  TodoApp.swift
//  Todo
//
//  Created by Мурад on 5/1/25.
//

import SwiftUI

@main
struct TodoApp: App {
    var todoRepository = TodoRepository()
    let persistenceController = PersistenceController.shared
    var body: some Scene {
        WindowGroup {
            ContentView().environment(\.managedObjectContext, persistenceController.context).background(Color(red: 243 / 255, green: 243 / 255, blue: 243 / 255, opacity: 1))
        }
    }
}
