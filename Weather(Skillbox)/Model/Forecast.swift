import Foundation

struct Forecast {
    
    let day: String
    let dayDescription:String
    let imageURL:URL?
    var backupImageData: Data?
    let weather: Weather
    
    
}
