import Foundation
import Realm
import RealmSwift

class Task: Object {
    
    @objc dynamic var name = ""
    @objc dynamic var dateCreated = Date()
    @objc dynamic var isCompleted = false
    
    convenience init(name:String,dateCreated:Date) {
        self.init()
        self.name = name
        self.dateCreated = dateCreated
    }
    
    
    
}
