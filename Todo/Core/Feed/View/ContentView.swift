//
//  ContentView.swift
//  Todo
//
//  Created by Мурад on 5/1/25.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @StateObject var viewModel = ContentViewModel()
    
    @FetchRequest(
    entity: Task.entity(),
    sortDescriptors: [NSSortDescriptor(keyPath: \Task.createdAt, ascending: false)]
)
    private var todos: FetchedResults<Task>
    
    private var filteredTodos: [Task] {
        switch viewModel.filter {
            case .all:
                return todos.map { $0 }
            case .completed:
                return todos.filter { $0.completed }
            case .active:
                return todos.filter { !$0.completed }
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
                    viewModel.activeSheet = .add
                    viewModel.todoText = ""
                    viewModel.todoDescription = ""
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
            
            CustomPicker(selectedOption: $viewModel.filter, todos: todos)
                .padding(.vertical)
            
            ScrollView {
                ForEach(filteredTodos, id: \.objectID) { todo in
                    TodoCard(todo: todo, onConfirm: {
                        viewModel.saveContext()
                    })
                        .onTapGesture {
                            viewModel.activeSheet = .check
                            viewModel.todoText = todo.todo!
                            viewModel.todoDescription = todo.userId!
                            viewModel.todoUid = todo.objectID
                        }
                }
            }
            
            Spacer()
        }
        .sheet(item: $viewModel.activeSheet) { sheet in
            switch sheet {
            case .add:
                CustomAlert(todoText: $viewModel.todoText, todoDescription: $viewModel.todoDescription, activeSheet: $viewModel.activeSheet) {
                    viewModel.addTodo()
                }
            case .check:
                CustomAlertCheck(todoText: $viewModel.todoText, todoDescription: $viewModel.todoDescription, onDelete: {
                    if let _ = viewModel.todoUid { viewModel.deleteTodo() }
                    viewModel.activeSheet = nil
                    }) {
                        viewModel.activeSheet = .change
                    }
                
            case .change:
                CustomAlert(todoText: $viewModel.todoText, todoDescription: $viewModel.todoDescription, activeSheet: $viewModel.activeSheet) {
                    viewModel.updateTodo()
                }
            }
        }
        .ignoresSafeArea(.all)
        .onAppear {
            if todos.isEmpty {
                viewModel.fetchTodo()
            }
        }
        .padding()
    }
}
