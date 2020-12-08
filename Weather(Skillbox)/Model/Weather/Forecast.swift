import Foundation

struct Forecast: Codable {
    
    let day: String
    let dayDescription:String
    let imageURL:URL?
    var backupImageData: Data?
    let weather: Weather
    
    
    init(day:String,dayDesc:String,imageURL:URL?,backup:Data? = nil,weather:Weather) {
        self.day = day
        self.dayDescription = dayDesc
        self.imageURL = imageURL
        self.backupImageData = backup
        self.weather = weather
    }
    
    
    
}
