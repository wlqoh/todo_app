//
//  TodoCard.swift
//  Todo
//
//  Created by Мурад on 5/1/25.
//

import SwiftUI

struct TodoCard: View {
    @ObservedObject var todo: Task
    var onConfirm: () -> Void
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    Text(todo.todo ?? "").fontWeight(.medium).font(.title2).foregroundStyle(Color(.black)).strikethrough(todo.completed)
                    Text(todo.userId ?? "").foregroundStyle(.gray).font(.caption).fontWeight(.medium)
                }
                Spacer()
                Button(action: {
                    todo.completed.toggle()
                    onConfirm()
                }) {
                    Image(systemName: todo.completed ? "checkmark.circle.fill" : "circle").resizable().frame(width: 25, height: 25)
                }
            }
            Divider()
            if (todo.createdAt != nil) {
                Text("\(todo.createdAt!.formatted(.dateTime.weekday().hour().minute()))").foregroundStyle(Color(.black))
            }}
        .padding().background(Color.white).clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
