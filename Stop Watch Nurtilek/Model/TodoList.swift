//
//  TodoList.swift
//  Stop Watch Nurtilek
//
//  Created by Nurtilek Nurbekov on 4/5/20.
//  Copyright © 2020 neobis. All rights reserved.
//

import Foundation

class TodoList {
  
  var todos: [ChecklistItem] = []
  
  func newTodo() -> ChecklistItem {
    let item = ChecklistItem()
    item.checked  = true
    todos.append(item)
    return item
  }
}
