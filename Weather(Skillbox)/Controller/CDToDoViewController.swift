import UIKit
import CoreData

class CDToDoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var newTaskTextField: UITextField!
    
    lazy var fetchedResultsController : NSFetchedResultsController<Tasks>? = {
        let request : NSFetchRequest<Tasks> = NSFetchRequest(entityName: "Tasks")
        request.sortDescriptors = [NSSortDescriptor(key:"dateCreated",ascending:false)]
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
            return taskCell
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
            textField.resignFirstResponder()
            tableView.reloadData()
        }
        return true
    }
}
