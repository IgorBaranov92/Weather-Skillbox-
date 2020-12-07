import Foundation

extension Date {
    
    static func rigthDateFrom(_ selectedDate : Date) -> Date {
        var dateComponents = DateComponents()
        let calendar = Calendar.current
        dateComponents.hour = calendar.component(.hour, from: selectedDate)
        dateComponents.minute = calendar.component(.minute, from: selectedDate)
        dateComponents.timeZone = TimeZone(abbreviation: "GMT")
        let rightDate = calendar.date(from: dateComponents)!
        return rightDate
    }
    
    
    static func getHoursAndMinutes(_ date:Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm "
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        let stringFromDate = dateFormatter.string(from: Date.rigthDateFrom(date))
        return stringFromDate
    }
    
    func getWeekday() -> String {
        let weekday = Calendar.current.component(.weekday, from: self)
        switch weekday {
        case 1: return "Воскресенье"
        case 2: return "Понедельник"
        case 3: return "Вторник"
        case 4: return "Среда"
        case 5: return "Четверг"
        case 6: return "Пятница"
        case 7: return "Суббота"
        default: return "Не могу определить что за день недели"
        }
    }
    
    func getDayDesc(full:Bool) -> String {
        let month = Calendar.current.component(.month, from: self)
        let day = Calendar.current.component(.day, from: self)
        let hour = Calendar.current.component(.hour, from: self)
        let minute = Calendar.current.component(.minute, from: self)
        var stringFromDate = "\(day)"
        switch month {
        case 1: stringFromDate += " января"
        case 2: stringFromDate += " февраля"
        case 3: stringFromDate += " марта"
        case 4: stringFromDate += " апреля"
        case 5: stringFromDate += " мая"
        case 6: stringFromDate += " июня"
        case 7: stringFromDate += " июля"
        case 8: stringFromDate += " августа"
        case 9: stringFromDate += " сентября"
        case 10: stringFromDate += " октября"
        case 11: stringFromDate += " ноября"
        case 12: stringFromDate += " декабря"
        default:break
        }
        if stringFromDate.first == "0" { stringFromDate.removeFirst() }
        if full { stringFromDate += " \(hour):\(minute)" }
        if minute == 0 && full { stringFromDate += "0" }
        return stringFromDate
    }

    
    func getDay() -> Date {
        let components = Calendar.current.dateComponents([.year, .month, .day,.hour], from: self)
        let date = Calendar.current.date(from: components)
        return date!
    }

     
    
}
