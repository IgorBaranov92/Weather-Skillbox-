import UIKit

class RealmViewController: PersistenseViewController, UITextFieldDelegate, UITableViewDataSource {

  
    var tasks = TasksR()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.all.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath)
        if let taskCell = cell as? ToDoTableViewCell {
            taskCell.taskLabel.text = tasks.all[indexPath.row].name
            taskCell.accessoryType = tasks.all[indexPath.row].isCompleted ? .checkmark : .none
            return taskCell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tasks.delete(tasks.all[indexPath.row])
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView,didSelectRowAt: indexPath)
        tasks.complete(tasks.all[indexPath.row])
        if let taskCell = tableView.cellForRow(at: indexPath) as? ToDoTableViewCell {
            taskCell.accessoryType = tasks.all[indexPath.row].isCompleted ? .checkmark : .none
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text == "" {
            let alert = UIAlertController(title: "Ошибка", message: "Введите название задачи", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Хорошо", style: .cancel))
            present(alert, animated: true)
        } else {
            tasks.appendNew(Task(name: textField.text!, dateCreated: Date()))
            textField.text = ""
            textField.placeholder = "Новая задача"
            textField.resignFirstResponder()
            tableView.reloadData()
        }
        return true
    }

    override func tasksChooserChanged(_ sender: UISegmentedControl) {
//        let index = sender.selectedSegmentIndex
//        switch index {
//        case 0: tasks = tasks.all.filter()
//        case 1: tasks = tasks.all.filter()
//        case 2: tasks = tasks.all.filter()
//        default:break
//        }
        tableView.reloadData()
    }
}
