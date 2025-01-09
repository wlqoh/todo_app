//
//  CustomPicker.swift
//  Todo
//
//  Created by Мурад on 6/1/25.
//

import SwiftUI

struct CustomPicker: View {
    @Binding var selectedOption: FilterOption
    let todos: FetchedResults<Task>
    var body: some View {
        HStack {
            let completed = todos.filter { $0.completed }.count
            let active = todos.filter { !$0.completed }.count
            ForEach(FilterOption.allCases) { option in
                HStack {
                    if (option == FilterOption.completed) {
                        Text(FilterOption.completed.rawValue)
                            .foregroundStyle(selectedOption == option ? Color.blue : Color.gray)
                            .onTapGesture {
                                withAnimation {
                                    selectedOption = option
                                }
                            }
                        Text("\(completed)").frame(width: 40).foregroundStyle(Color.white).background(selectedOption == option ? Color.blue : Color.gray).clipShape(RoundedRectangle(cornerRadius: 16)).onTapGesture {
                            withAnimation {
                                selectedOption = option
                            }
                        }
                    }
                    else if (option == FilterOption.active) {
                        Text(FilterOption.active.rawValue)
                            .foregroundStyle(selectedOption == option ? Color.blue : Color.gray)
                            .onTapGesture {
                                withAnimation {
                                    selectedOption = option
                                }
                            }.padding(.leading, 10)
                        Text("\(active)").frame(width: 40).foregroundStyle(Color.white).background(selectedOption == option ? Color.blue : Color.gray).clipShape(RoundedRectangle(cornerRadius: 16)).onTapGesture {
                            withAnimation {
                                selectedOption = option
                            }
                        }
                    }
                    else {
                        Text(FilterOption.all.rawValue)
                            .foregroundStyle(selectedOption == option ? Color.blue : Color.gray)
                            .onTapGesture {
                                withAnimation {
                                    selectedOption = option
                                }
                            }
                        Text("\(todos.count)").frame(width: 40).foregroundStyle(Color.white).background(selectedOption == option ? Color.blue : Color.gray).clipShape(RoundedRectangle(cornerRadius: 16)).onTapGesture {
                            withAnimation {
                                selectedOption = option
                            }
                        }.padding(.trailing, 10)
                        Text("|").foregroundStyle(.gray)
                    }
                }
            }
        }
    }
}
