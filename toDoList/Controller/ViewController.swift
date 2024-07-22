//
//  ViewController.swift
//  toDoList
//
//  Created by Lisa J on 7/15/24.
//

import UIKit

protocol TaskDelegate {
    func passTask(toDoList: [ToDoItem], index: Int)
}

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var delegate: TaskDelegate?
    var toDoList: [ToDoItem] = []
    private var taskManager = TaskManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateTasks()
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

    func loadToDoList() -> [ToDoItem] {
        let defaults = UserDefaults.standard
        if let savedToDoList = defaults.object(forKey: "ToDoList") as? Data {
            if let decodedToDoList = try? JSONDecoder().decode([ToDoItem].self, from: savedToDoList) {
                return decodedToDoList
            }
        }
        return []
    }

    func updateTasks() {
//        toDoList = loadToDoList()
        toDoList = taskManager.getItems()
        tableView.reloadData()
    }


    @IBAction func didTapAdd() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "entry") as! EntryViewController
        vc.title = "New Task"
        vc.update = {
            DispatchQueue.main.async { [weak self] in
                self?.updateTasks()
            }
        }
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
            //save todolisthere
//            saveToDoList(toDoList: toDoList)
            taskManager.saveItems(toDoItems: toDoList)
            updateTasks()
        }
    }
    
    func saveToDoList(toDoList: [ToDoItem]) {
        let defaults = UserDefaults.standard
        if let encoded = try? JSONEncoder().encode(toDoList) {
            defaults.set(encoded, forKey: "ToDoList")
        }
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "task") as! TaskViewController
        vc.title = "New Task"
        self.delegate = vc
        vc.update = {
            DispatchQueue.main.async { [weak self] in
                self?.updateTasks()
            }
        }
        delegate?.passTask(toDoList: toDoList, index: indexPath.row)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//        toDoList.swapAt(sourceIndexPath.row, destinationIndexPath.row)
        taskManager.swapItem(startingIndex: sourceIndexPath.row, destinationIndex: destinationIndexPath.row)
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskManager.getItems().count
//        return toDoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TaskCell
//        cell.taskLabel.text = toDoList[indexPath.row].title
        cell.taskLabel.text = taskManager.getItems()[indexPath.row].title
        
        return cell
    }
}
