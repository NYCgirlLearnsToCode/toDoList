//
//  EntryViewController.swift
//  toDoList
//
//  Created by Lisa J on 7/15/24.
//

import UIKit

class EntryViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var field: UITextField!
    
    enum State {
        case save
        case edit
    }
    
    var update: (() -> Void)?
    var toDoList: [ToDoItem] = []
    var state: State = .save
    var index: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        field.delegate = self
        switch state {
            case .save:
                navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveTask))
            case .edit:
            // TODO - get text from taskvc
            field.text = toDoList[index].title
                navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(editTask))
        }
        
        print("viewDidLoad entryvc")
    }

    
    func loadToDoList() -> [ToDoItem] {
        let defaults = UserDefaults.standard
        if let savedToDoList = defaults.object(forKey: "ToDoList") as? Data {
            if let decodedToDoList = try? JSONDecoder().decode([ToDoItem].self, from: savedToDoList) {
                return decodedToDoList
            }
        }
        return []
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        saveTask()
        return true
    }
    
    // TODO - save data
    func saveToDoList(toDoList: [ToDoItem]) {
        let defaults = UserDefaults.standard
        if let encoded = try? JSONEncoder().encode(toDoList) {
            defaults.set(encoded, forKey: "ToDoList")
        }
    }
    
    @objc func editTask() {
        guard let text = field.text, !text.isEmpty else { return }
        if toDoList.isEmpty {
            toDoList = loadToDoList()
        }

        let updatedItem = ToDoItem(title: text, isCompleted: false)
        toDoList[index] = updatedItem
        saveToDoList(toDoList: toDoList)
        //update tableview
        update?()
        navigationController?.popToRootViewController(animated: true)
    }

    @objc func saveTask() {
        guard let text = field.text, !text.isEmpty else { return }
        toDoList = loadToDoList()
        let newItem = ToDoItem(title: text, isCompleted: false)
        toDoList.append(newItem)
        saveToDoList(toDoList: toDoList)
        //update tableview
        update?()
        navigationController?.popViewController(animated: true)
    }
}
