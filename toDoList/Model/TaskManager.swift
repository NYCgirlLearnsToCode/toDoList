//
//  TaskManager.swift
//  toDoList
//
//  Created by Lisa J on 7/22/24.
//

import Foundation

class TaskManager {
    private let userDefaultsKey = "ToDoList"
    private var toDoItems: [ToDoItem] = []
    
    init() {
        loadItems()
    }

    private func loadItems() {
        let defaults = UserDefaults.standard
        if let savedToDoList = defaults.object(forKey: userDefaultsKey) as? Data {
            if let decodedToDoList = try? JSONDecoder().decode([ToDoItem].self, from: savedToDoList) {
                toDoItems = decodedToDoList
            }
        }
    }

    func addItem(item: ToDoItem) {
        toDoItems.append(item)
        saveItems()
    }

    func updateItem(index: Int, newItem: ToDoItem) {
        toDoItems[index] = newItem
        saveItems()
    }
    
    func swapItem(startingIndex: Int, destinationIndex: Int) {
        toDoItems.swapAt(startingIndex, destinationIndex)
        saveItems()
    }
    
    func saveItems() {
        let defaults = UserDefaults.standard
        if let encoded = try? JSONEncoder().encode(toDoItems) {
            defaults.set(encoded, forKey: userDefaultsKey)
        }
    }
    
    func deleteItem(index: Int) {
        toDoItems.remove(at: index)
        saveItems()
    }
    
    func getItems() -> [ToDoItem] {
        return toDoItems
    }
}
