//
//  ToDoItem.swift
//  toDoList
//
//  Created by Lisa J on 7/19/24.
//

import Foundation

// making it codable because NSUserDefaults can only store certain types of data string, int, bool, data
struct ToDoItem: Codable {
    var title: String
    var isCompleted: Bool
}
