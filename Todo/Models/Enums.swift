//
//  FilterOption.swift
//  Todo
//
//  Created by Мурад on 6/1/25.
//

import Foundation

enum FilterOption: String, CaseIterable, Identifiable {
    case all = "All"
    case active = "Open"
    case completed = "Closed"
    
    var id: String { rawValue }
}
enum ActiveSheet: Identifiable {
    case add, check, change
    
    var id: Int { hashValue }
}
