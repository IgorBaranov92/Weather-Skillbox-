import Foundation


struct Weather {

    let city:String
    let windSpeed:Int
    let sunset:String
    let visibility: Double
    let weather:String
    let temperatureInCelsium:Int
    let temperatureInFahrenheit: Int
    let humidity: Int
    let iconID: String
    
    init?(json:[String:Any]) {
        guard let visibility = json["visibility"] as? Double ,
              let name = json["name"] as? String,
              let wind = json["wind"] as? [String:Int],
              let speed = wind["speed"],
              let sys = json["sys"] as? [String: Any],
              let sunset = sys["sunset"] as? Int,
              let main = json["main"] as? [String:Any],
              let temp = main["temp"] as? Double,
              let humidity = main["humidity"] as? Int ,
              let weather = json["weather"] as? [[String:Any]],
              let first = weather.first,
              let description = first["description"] as? String,
              let icodID = first["icon"] as? String else { return nil }
              
        self.visibility = visibility/1000
        self.city = name
        self.windSpeed = speed
        self.temperatureInCelsium = Int(temp - 273)
        self.humidity = humidity
        self.iconID = icodID
        self.weather = description
        self.temperatureInFahrenheit = self.temperatureInCelsium*9/5 + 32
        let sunsetDate = Date(timeIntervalSince1970: Double(sunset))
        let moscowSunsetDate = Date.getHoursAndMinutes(sunsetDate)
        self.sunset = moscowSunsetDate

    }

    init(tempInKelvin:Int,humidity:Int,iconID:String,windSpeed:Int,weather:String,visibility:Double) {
        self.temperatureInCelsium = tempInKelvin - 273
        self.temperatureInFahrenheit = self.temperatureInCelsium*9/5 + 32
        self.humidity = humidity
        self.iconID = iconID
        self.weather = weather
        self.windSpeed = windSpeed
        self.city = "Москва"
        self.sunset = "" // don't care
        self.visibility = visibility
    }
    

    
}
