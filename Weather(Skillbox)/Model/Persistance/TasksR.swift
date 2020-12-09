import Foundation
import Realm
import RealmSwift

class TasksR {

    private let realm = try! Realm()
    
    func appendNew(_ task:Task) {
        try! realm.write {
            realm.add(task)
        }
    }
    
    func delete(_ task:Task) {
        try! realm.write {
            realm.delete(task)
        }
    }
    
    func complete(_ task:Task) {
        try! realm.write {
            task.isCompleted = !task.isCompleted
        }
    }

    func all(predicate:String) -> Results<Task> {
        return realm.objects(Task.self).sorted(byKeyPath: "dateCreated",ascending: false).filter(NSPredicate(format: predicate))

    }
    
}
