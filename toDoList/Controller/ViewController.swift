//
//  ViewController.swift
//  toDoList
//
//  Created by Lisa J on 7/15/24.
//

import UIKit

protocol TaskDelegate {
    func passTask(toDoItem: ToDoItem, index: Int)
}

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var delegate: TaskDelegate?
    private var taskManager = TaskManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        setupViews()
        self.title = "Tasks"
        print("viewdidload vc")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    @IBAction func didTapAdd() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "entry") as! EntryViewController
        vc.title = "New Task"
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func setupViews() {
        let leftBarButtonItem = UIBarButtonItem(title: "sort", style: .done, target: self, action: #selector(didTapSort))
        self.navigationItem.leftBarButtonItem = leftBarButtonItem
    }

    @objc func didTapSort() {
        //how can I tell it's initial vs finish?
        if tableView.isEditing {
            //start editing
            tableView.isEditing = false
        } else {
            // done editing
            tableView.isEditing = true
            taskManager.saveItems()
            tableView.reloadData()
        }
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "task") as! TaskViewController
        vc.title = "New Task"
        self.delegate = vc
        vc.delegate = self
        delegate?.passTask(toDoItem: taskManager.getItems()[indexPath.row], index: indexPath.row)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        taskManager.swapItem(startingIndex: sourceIndexPath.row, destinationIndex: destinationIndexPath.row)
        tableView.reloadData()
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskManager.getItems().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TaskCell
        cell.taskLabel.text = taskManager.getItems()[indexPath.row].title
        
        return cell
    }
}

extension ViewController: EntryVCDelegate {
    func addNewItem(toDoItem: ToDoItem) {
        taskManager.addItem(item: toDoItem)
        tableView.reloadData()
    }
    
    func editItem(toDoItem: ToDoItem, index: Int) {
        taskManager.updateItem(index: index, newItem: toDoItem)
        tableView.reloadData()
    }
}

extension ViewController: TaskVCDelegate {
    func deleteTask(index: Int) {
        taskManager.deleteItem(index: index)
        tableView.reloadData()
    }
}
