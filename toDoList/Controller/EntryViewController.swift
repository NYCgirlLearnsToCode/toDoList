//
//  EntryViewController.swift
//  toDoList
//
//  Created by Lisa J on 7/15/24.
//

import UIKit

protocol EntryVCDelegate {
    func addNewItem(toDoItem: ToDoItem)
    func editItem(toDoItem: ToDoItem, index: Int)
}

class EntryViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var field: UITextField!
    
    var delegate: EntryVCDelegate?
    
    enum State {
        case save
        case edit
    }
    
    var update: (() -> Void)?
    var toDoItem: ToDoItem!
    var state: State = .save
    var index: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        field.delegate = self
        switch state {
            case .save:
                navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveTask))
            case .edit:
            field.text = toDoItem.title
                navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(editTask))
        }
        
        print("viewDidLoad entryvc")
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        saveTask()
        return true
    }
    
    @objc func editTask() {
        guard let text = field.text, !text.isEmpty else { return }

        let updatedItem = ToDoItem(title: text, isCompleted: false)
        delegate?.editItem(toDoItem: updatedItem, index: index)
        navigationController?.popToRootViewController(animated: true)
    }

    @objc func saveTask() {
        guard let text = field.text, !text.isEmpty else { return }
        let newItem = ToDoItem(title: text, isCompleted: false)
        delegate?.addNewItem(toDoItem: newItem)
        navigationController?.popViewController(animated: true)
    }
}
