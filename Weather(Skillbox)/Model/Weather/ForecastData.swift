import Foundation

struct ForecastData: Codable {
    
    private(set) var dailyForecast = [Forecast]()
    private(set) var hourForecast = [Forecast]()
    
    var type = ForecastType.daily
    var currentForecast:[Forecast] {
        switch type {
            case .daily: return dailyForecast
            case .hour: return hourForecast
        }
    }
    
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
    
    mutating func update(daily:[Forecast],hour:[Forecast]) {
        self.dailyForecast = daily
        self.hourForecast = hour
    }
    
    mutating func updateBackupDataAt(_ index:Int,backup:Data) {
        switch type {
            case .hour: hourForecast[index].backupImageData = backup
            case .daily: dailyForecast[index].backupImageData = backup
        }
    }
    
    enum ForecastType {
        case daily
        case hour
    }
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        dailyForecast = try container.decode([Forecast].self, forKey: .dailyForecast)
        hourForecast = try container.decode([Forecast].self, forKey: .hourForecast)

    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(dailyForecast, forKey: .dailyForecast)
        try container.encode(hourForecast, forKey: .hourForecast)

    }
    
    private enum CodingKeys:String,CodingKey {
        case dailyForecast = "dailyForecast"
        case hourForecast = "hourForecast"
        
    }
    
    
}
