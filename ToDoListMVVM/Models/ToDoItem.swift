//
//  ToDoItem.swift
//  ToDoListMVVM
//
//  Created by Bektur Mamytov on 3/5/23.
//

import Foundation

struct TodoItem: Encodable, Decodable {
    var title: String
    var isCompleted: Bool
}
