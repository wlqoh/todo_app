//
//  ContentView.swift
//  Todo
//
//  Created by Мурад on 5/1/25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @EnvironmentObject var todoRepository: TodoRepository
    @State private var filter: FilterOption = .all
    @State private var activeSheet: ActiveSheet?
    @State private var todoText: String = ""
    @State private var todoDescription: String = ""
    @State private var todoUid: NSManagedObjectID?
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        entity: Task.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Task.createdAt, ascending: true)]
    )
    private var todos: FetchedResults<Task>
    
    private var filteredTodos: [Task] {
        switch filter {
        case .all:
            return todos.map { $0 }
        case .completed:
            return todos.filter { $0.completed }
        case .active:
            return todos.filter { !$0.completed }
        }
    }
    
    
    private func deleteTodo (todoUid: NSManagedObjectID) {
        let object = viewContext.object(with: todoUid)
        viewContext.delete(object)
        
        saveContext()
    }
    
    private func updateTodo(todoUid: NSManagedObjectID, todoText: String, todoDescription: String) {
        let object = viewContext.object(with: todoUid)
        if let todo = object as? Task {
            todo.todo = todoText
            todo.userId = todoDescription
        }
    }
    
    private func addTodo(task: String, description: String) {
        withAnimation {
            let newTodo = Task(context: viewContext)
            newTodo.userId = description
            newTodo.todo = task
            newTodo.createdAt = Date()
            newTodo.completed = false
        }
        saveContext()
    }
    
    /// Функция для сохранения контекста Core Data
    private func saveContext() {
        do {
            try viewContext.save()
            print("Changes saved successfully.")
        } catch {
            print("Error saving context: \(error)")
        }
    }
    
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    Text("Today's Task")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color(.systemBackground))
                    Text(Date.now, format: .dateTime.weekday().day().month())
                        .font(.callout)
                        .foregroundColor(.gray)
                }
                Spacer()
                Button(action: {
                    activeSheet = .add
                    todoText = ""
                    todoDescription = ""
                }) {
                    Text("+  NewTask")
                        .fontWeight(.medium)
                        .font(.title3)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(Color.blue.opacity(0.3))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            CustomPicker(selectedOption: $filter, todos: todos)
                .padding(.vertical)
            
            ScrollView {
                ForEach(filteredTodos, id: \.objectID) { todo in
                    TodoCard(todo: todo)
                        .onTapGesture {
                            activeSheet = .check
                            todoText = todo.todo!
                            todoDescription = todo.userId!
                            todoUid = todo.objectID
                        }
                }
            }
            
            Spacer()
        }
        .sheet(item: $activeSheet) { sheet in
            switch sheet {
            case .add:
                CustomAlert(todoText: $todoText, todoDescription: $todoDescription, activeSheet: $activeSheet) {
                    addTodo(task: todoText, description: todoDescription)
                }
            case .check:
                CustomAlertCheck(todoText: $todoText, todoDescription: $todoDescription, onDelete: {
                    if let uId = todoUid { deleteTodo(todoUid: uId) }
                        activeSheet = nil
                    }) {
                        activeSheet = .change
                    }
                
            case .change:
                CustomAlert(todoText: $todoText, todoDescription: $todoDescription, activeSheet: $activeSheet) {
                    updateTodo(todoUid: todoUid!, todoText: todoText, todoDescription: todoDescription)
                }
            }
        }
        .ignoresSafeArea(.all)
        .onAppear {
            if todos.isEmpty {
                todoRepository.fetch(context: viewContext)
            }
        }
        .padding()
    }
}
