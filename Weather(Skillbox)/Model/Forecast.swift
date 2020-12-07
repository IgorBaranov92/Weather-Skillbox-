import Foundation

struct Forecast: Codable {
    
    let day: String
    let dayDescription:String
    let imageURL:URL?
    var backupImageData: Data?
    let weather: Weather
    
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
    
    init?(json: Data) {
        if let value = try? JSONDecoder().decode(Forecast.self, from: json) {
            self = value
        } else {
            return nil
        }
    }
    
    init(day:String,dayDesc:String,imageURL:URL?,backup:Data? = nil,weather:Weather) {
        self.day = day
        self.dayDescription = dayDesc
        self.imageURL = imageURL
        self.backupImageData = backup
        self.weather = weather
    }
    
    
    
}
