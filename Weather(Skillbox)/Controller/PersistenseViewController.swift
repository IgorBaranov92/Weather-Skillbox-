import UIKit

class PersistenseViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var newTaskTextField: UITextField!
    @IBOutlet weak var tasksChooser: UISegmentedControl!

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func tasksChooserChanged(_ sender:UISegmentedControl) {
        
    }
    
}
