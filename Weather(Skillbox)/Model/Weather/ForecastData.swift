import Foundation

struct ForecastData: Codable {
    
    private(set) var dailyForecast = [Forecast]()
    private(set) var hourForecast = [Forecast]()
    
    var json: Data? {
        return try? JSONEncoder().encode(self)
    }
    
    init?(json: Data) {
        if let value = try? JSONDecoder().decode(ForecastData.self, from: json) {
            self = value
        } else {
            return nil
        }
    }
    
    
}
