//
//  ChecklistViewController.swift
//  Stop Watch Nurtilek
//
//  Created by Nurtilek Nurbekov on 4/5/20.
//  Copyright © 2020 neobis. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController {

  var todoList: TodoList
  
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
  @IBAction func addItem(_ sender: Any) {
    let newRowIndex = todoList.todos.count
    let indexPath = IndexPath(row: newRowIndex, section: 0)
    let indexPaths = [indexPath]
    tableView.insertRows(at: indexPaths, with: .automatic)
}
  
  required init?(coder aDecoder: NSCoder) {
    todoList = TodoList()
    super.init(coder: aDecoder)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    loadData()
    navigationController?.navigationBar.prefersLargeTitles = true
    
    if self.revealViewController() != nil {
        menuButton.target = self.revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
    }
  }
    
    func loadData() {
        if let data = UserDefaults.standard.object(forKey: "SavedArray") as? Data {
            if let storedData = NSKeyedUnarchiver.unarchiveObject(with: data) as? [ChecklistItem] {
                todoList.todos = storedData
            }
        }
        tableView.reloadData()
    }
    
    func saveData() {
        let placesData = NSKeyedArchiver.archivedData(withRootObject: todoList.todos)
        UserDefaults.standard.set(placesData, forKey: "SavedArray")
        UserDefaults.standard.synchronize()
    }
    
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return todoList.todos.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
    let item = todoList.todos[indexPath.row]
    configureText(for: cell, with: item)
    configureCheckmark(for: cell, with: item)
    
    return cell
}

  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let cell = tableView.cellForRow(at: indexPath) {
      let item = todoList.todos[indexPath.row]
      configureCheckmark(for: cell, with: item)
      tableView.deselectRow(at: indexPath, animated: true)
    }
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    
    todoList.todos.remove(at: indexPath.row)
    let indexPaths = [indexPath]
    tableView.deleteRows(at: indexPaths, with: .automatic)
    saveData()

  }
    
  
  
  func configureText(for cell: UITableViewCell, with item: ChecklistItem) {
    if let checkmarkCell = cell as? ChecklistTableViewCell {
      checkmarkCell.todoTextLabel.text = item.text
    }
}
  
  func configureCheckmark(for cell: UITableViewCell, with item: ChecklistItem) {
    guard let checkmarkCell = cell as? ChecklistTableViewCell else {
      return
    }
    if item.checked! {
      checkmarkCell.checkmarkLabel.text = "√"
    } else {
      checkmarkCell.checkmarkLabel.text = ""
    }
    item.toggleChecked()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "AddItemSegue" {
      if let itemDetailViewController = segue.destination as? ItemDetailViewController {
        itemDetailViewController.delegate = self
        itemDetailViewController.todoList = todoList
      }
    } else if segue.identifier == "EditItemSegue" {
      if let itemDetailViewController = segue.destination as? ItemDetailViewController {
        if let cell = sender as? UITableViewCell,
           let indexPath = tableView.indexPath(for: cell) {
          let item = todoList.todos[indexPath.row]
          itemDetailViewController.itemToEdit = item
          itemDetailViewController.delegate = self
        }
      }
    }
  }

    
}

extension ChecklistViewController: ItemDetailViewControllerDelegate {
  func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
    navigationController?.popViewController(animated: true)
  }
  
  func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
    navigationController?.popViewController(animated: true)
    let rowIndex = todoList.todos.count - 1
    let indexPath = IndexPath(row: rowIndex, section: 0)
    let indexPaths = [indexPath]
    tableView.insertRows(at: indexPaths, with: .automatic)
    tableView.reloadData()
    saveData()
}
  
  func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
    if let index = todoList.todos.firstIndex(of: item) {
      let indexPath = IndexPath(row: index, section: 0)
      if let cell = tableView.cellForRow(at: indexPath) {
        configureText(for: cell, with: item)
      }
    }
    navigationController?.popViewController(animated: true)
    saveData()
  }
}

