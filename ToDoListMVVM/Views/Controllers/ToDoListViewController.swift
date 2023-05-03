//
//  ViewController.swift
//  ToDoListMVVM
//
//  Created by Bektur Mamytov on 3/5/23.
//

import UIKit

class TodoListViewController: UIViewController {
    
    var viewModel: TodoListViewModel!
    var todoItems: [TodoItem] = []
    
    @IBOutlet weak var tableView: UITableView!

   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Retrieve the saved todo items from UserDefaults
        if let data = UserDefaults.standard.data(forKey: "todoItems") {
            let todoItems = try! JSONDecoder().decode([TodoItem].self, from: data)
            viewModel = TodoListViewModel(todoItems: todoItems)
        } else {
            viewModel = TodoListViewModel(todoItems: todoItems)
        }
        
        tableView.dataSource = self
        tableView.delegate = self
    }

    @IBAction func addButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Add Todo Item", message: nil, preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter title"
        }
        let addAction = UIAlertAction(title: "Add", style: .default) { (_) in
            guard let title = alertController.textFields?.first?.text else { return }
            self.viewModel.addTodoItem(title: title)
            self.tableView.reloadData()
            self.saveTodoItems() // Save the todo items
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
   
    func saveTodoItems() {
        // Convert the todo items to a data representation
        let data = try! JSONEncoder().encode(viewModel.todoItems)
        
        // Save the data to UserDefaults
        UserDefaults.standard.set(data, forKey: "todoItems")
    }

    
}

extension TodoListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.todoItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath)
        let todoItem = viewModel.todoItems[indexPath.row]
        cell.textLabel?.text = todoItem.title
        cell.accessoryType = todoItem.isCompleted ? .checkmark : .none
        return cell
    }
}

extension TodoListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.toggleTodoItemCompletion(index: indexPath.row)
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            viewModel.removeTodoItem(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            saveTodoItems() // Save the todo items
        }
    }
}


