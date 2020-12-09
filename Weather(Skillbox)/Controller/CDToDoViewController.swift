import UIKit
import CoreData

class CDToDoViewController: PersistenseViewController, UITableViewDataSource, UITextFieldDelegate, NSFetchedResultsControllerDelegate {
    
   
    lazy var fetchedResultsController : NSFetchedResultsController<Tasks>? = {
        let request : NSFetchRequest<Tasks> = NSFetchRequest(entityName: "Tasks")
        request.sortDescriptors = [NSSortDescriptor(key:"dateCreated",ascending:false)]
        request.predicate = self.predicate
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: AppDelegate.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        aFetchedResultsController.delegate = self
        try? aFetchedResultsController.performFetch()
        return aFetchedResultsController
    }()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController?.sections![0].numberOfObjects ?? 0

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath)
        if let taskCell = cell as? ToDoTableViewCell, let task = fetchedResultsController?.object(at: indexPath) {
            taskCell.taskLabel.text = task.name
            taskCell.accessoryType = task.isCompleted ? .checkmark : .none
            return taskCell
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView,didSelectRowAt: indexPath)
        if predicate == nil, let task = fetchedResultsController?.object(at: indexPath) {
            task.isCompleted = !task.isCompleted
            try? AppDelegate.viewContext.save()
            if let taskCell = tableView.cellForRow(at: indexPath) as? ToDoTableViewCell {
                taskCell.accessoryType = task.isCompleted ? .checkmark : .none
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete, let object = fetchedResultsController?.object(at: indexPath) {
                AppDelegate.viewContext.delete(object)
                try? AppDelegate.viewContext.save()
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
            case .insert : tableView.insertRows(at: [newIndexPath!], with: .fade)
            case .delete : tableView.deleteRows(at: [indexPath!], with: .fade)
        default:break
        }
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text == "" {
            let alert = UIAlertController(title: "Ошибка", message: "Введите название задачи", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Хорошо", style: .cancel))
            present(alert, animated: true)
        } else {
            let task = Tasks(context: AppDelegate.viewContext)
            task.dateCreated = Date()
            task.name = textField.text
            try? AppDelegate.viewContext.save()
            textField.text = ""
            textField.placeholder = "Новая задача"
            textField.resignFirstResponder()
            tableView.reloadData()
        }
        return true
    }
    
    private var predicate: NSPredicate?
    
    override func tasksChooserChanged(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        switch index {
            case 0: predicate = nil
            case 1: predicate = NSPredicate(format: "isCompleted == false")
            case 2: predicate = NSPredicate(format: "isCompleted == true")
        default:break
        }
        fetchedResultsController?.fetchRequest.predicate = predicate
        try? fetchedResultsController?.performFetch()
        tableView.reloadData()
    }
    

}
