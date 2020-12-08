import Foundation
import Realm
import RealmSwift

class Task: Object {
    
    @objc dynamic var name = ""
    @objc dynamic var dateCreated = Date()
    
    convenience init(name:String,dateCreated:Date) {
        self.init()
        self.name = name
        self.dateCreated = dateCreated
    }
    
    
    
}
