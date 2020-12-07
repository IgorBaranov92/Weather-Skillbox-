import Foundation


extension String {
    var capitalizedFirst:String {
      return prefix(1).uppercased() + lowercased().dropFirst()
    }
    
    func createDate() -> Date?  {
        //2020-12-02 09:00:00
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = dateFormatter.date(from:self)
        let calendar = Calendar.current
        if let date = date {
            let components = calendar.dateComponents([.year, .month, .day, .hour,.minute,.second], from: date)
            let finalDate = calendar.date(from:components) ?? Date()
            return finalDate.addingTimeInterval(60*60*3)
        } else {
            return nil
        }
        
    }
    
}
