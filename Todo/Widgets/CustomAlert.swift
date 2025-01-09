//
//  CustomAlert.swift
//  Todo
//
//  Created by Мурад on 6/1/25.
//

import SwiftUI

struct CustomAlert: View {
    @Binding var todoText: String
    @Binding var todoDescription: String
    @Binding var activeSheet: ActiveSheet?
    var onConfirm: () -> Void
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Input task name", text: $todoText)
                TextField("Input task description", text: $todoDescription)
                
                Button("Cancel") {
                    activeSheet = nil
                    todoText = ""
                    todoDescription = ""
                }
                .foregroundColor(.red)
            }.toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        onConfirm()
                        todoText = ""
                        todoDescription = ""
                        activeSheet = nil
                    }
                }
            }
        }}
}

struct CustomAlertCheck: View {
    @Binding var todoText: String
    @Binding var todoDescription: String
    var onDelete: () -> Void
    var onEdit: () -> Void
    
    var body: some View {
        NavigationView {
            VStack {
                Text(todoText)
                    .padding()
                Text(todoDescription)
                    .padding()
                
                Spacer()
                Button("Delete") {
                    onDelete()
                }
                
            }.toolbar{
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Edit") {
                        onEdit()
                    }
                }
            }}
    }
}

