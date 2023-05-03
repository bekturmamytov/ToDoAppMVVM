//
//  ViewModel.swift
//  ToDoListMVVM
//
//  Created by Bektur Mamytov on 3/5/23.
//

import Foundation

class TodoListViewModel {
    var todoItems: [TodoItem]
    
    init(todoItems: [TodoItem]) {
        self.todoItems = todoItems
    }

    func addTodoItem(title: String) {
        let newItem = TodoItem(title: title, isCompleted: false)
        todoItems.append(newItem)
    }

    func toggleTodoItemCompletion(index: Int) {
        todoItems[index].isCompleted.toggle()
    }

    func removeTodoItem(at index: Int) {
        todoItems.remove(at: index)
    }
}
