import Foundation

class Defaults {
    
    static let shared = Defaults()
    
    private let nameKey = "Defaults.Name"
    private let surnameKey = "Defaults.Surname"
    
    var name: String? {
        get { return UserDefaults.standard.string(forKey: nameKey) }
        set { UserDefaults.standard.setValue(newValue, forKey: nameKey) }
    }
    
    var surname: String? {
        get { return UserDefaults.standard.string(forKey: surnameKey) }
        set { UserDefaults.standard.setValue(newValue, forKey: surnameKey) }
    }
    
    
}
