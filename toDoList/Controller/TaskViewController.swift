//
//  TaskViewController.swift
//  toDoList
//
//  Created by Lisa J on 7/15/24.
//

import UIKit

protocol TaskVCDelegate {
    func deleteTask(index: Int)
}

class TaskViewController: UIViewController, TaskDelegate {

    @IBOutlet weak var label: UILabel!
    
    var delegate: TaskVCDelegate?
    var toDoItem :ToDoItem!
    var index: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = toDoItem.title
        let editBarButtonItem = UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(editTask))
        let deleteBarButtonItem = UIBarButtonItem(title: "Delete", style: .done, target: self, action: #selector(deleteTask))
        
        navigationItem.rightBarButtonItems = [editBarButtonItem, deleteBarButtonItem]
        
        print("viewdidload taskvc")
    }
    
    func passTask(toDoItem: ToDoItem, index: Int) {
        self.toDoItem = toDoItem
        self.index = index
    }
    
    @objc func editTask() {
        //nav to entryvc and send the text and index
        let vc = storyboard?.instantiateViewController(withIdentifier: "entry") as! EntryViewController
        if let mainVC = self.navigationController?.viewControllers.first as? EntryVCDelegate {
            vc.delegate = mainVC
        }
        vc.title = "Edit task"
        vc.toDoItem = toDoItem
        vc.index = index
        vc.state = .edit
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc func deleteTask() {
        delegate?.deleteTask(index: index)
        navigationController?.popViewController(animated: true)
    }
}
