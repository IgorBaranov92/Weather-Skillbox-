import UIKit

class UserDefaultsViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameTextField: UITextField! { didSet {
        nameTextField.text = Defaults.shared.name
    }}
    
    @IBOutlet weak var surnameTextField: UITextField! { didSet {
        surnameTextField.text = Defaults.shared.surname
    }}
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        Defaults.shared.name = nameTextField.text
        Defaults.shared.surname = surnameTextField.text
        textField.resignFirstResponder()
        return true
    }
    
}
