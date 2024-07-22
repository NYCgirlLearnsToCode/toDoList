//
//  TaskViewController.swift
//  toDoList
//
//  Created by Lisa J on 7/15/24.
//

import UIKit


class TaskViewController: UIViewController, TaskDelegate {

    @IBOutlet weak var label: UILabel!
    
    var update: (() -> Void)?
    var toDoList : [ToDoItem] = []
    var index: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        label.text = toDoList[index].title
        label.sizeToFit()
        let editBarButtonItem = UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(editTask))
        let deleteBarButtonItem = UIBarButtonItem(title: "Delete", style: .done, target: self, action: #selector(deleteTask))
        
        navigationItem.rightBarButtonItems = [editBarButtonItem, deleteBarButtonItem]
        
        print("viewdidload taskvc")
    }
    
    func passTask(toDoList: [ToDoItem], index: Int) {
        self.toDoList = toDoList
        self.index = index
    }
    
    @objc func editTask() {
        //nav to entryvc and send the text and index
        let vc = storyboard?.instantiateViewController(withIdentifier: "entry") as! EntryViewController
        vc.title = "Edit task"
        vc.index = index
        vc.toDoList = toDoList
        vc.state = .edit
        //pass update along to EntryVC
        vc.update = update
        update?()
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc func deleteTask() {
        toDoList.remove(at: index)
        //save
        let defaults = UserDefaults.standard
        if let encoded = try? JSONEncoder().encode(toDoList) {
            defaults.set(encoded, forKey: "ToDoList")
        }
        // refresh tableview
        update?()
        navigationController?.popViewController(animated: true)
    }
}
