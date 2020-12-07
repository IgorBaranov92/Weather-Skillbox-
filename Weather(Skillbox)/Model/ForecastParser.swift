import Foundation


class ForecastParser {
    
    class func parse(json: [[String:Any]],completion:@escaping ([Forecast],[Forecast]) -> Void) {
        var hourForecast = [Forecast]()
        var dailyForecast = [Forecast]()
        
        var dates = [String]()
        
        
        for index in json.indices {
             if let stringDate = json[index]["dt_txt"] as? String ,
                let date = stringDate.createDate(),
                let visibility = json[index]["visibility"] as? Int,
                let windData = json[index]["wind"] as? [String:Any],
                let windSpeed = windData["speed"] as? Double,
                let weatherData = json[index]["main"] as? [String:Any],
                let humidity = weatherData["humidity"] as? Int,
                let tempInKelvin = weatherData["temp"] as? Double,
                let desc = json[index]["weather"] as? [[String:Any]],
                let first = desc.first,
                let weatherDesc = first["description"] as? String,
                let iconID = first["icon"] as? String  {
                let dayDesc = date.getDayDesc(full: true)
                let weekday = date.getWeekday()
                let weather = Weather(tempInKelvin: Int(tempInKelvin), humidity: humidity, iconID: iconID, windSpeed: Int(windSpeed), weather: weatherDesc, visibility: Double(visibility)/1000)
                let imageURL = URL(string: "http://openweathermap.org/img/wn/\(iconID)@2x.png")
                let cast = Forecast(day: dayDesc, dayDescription: weekday, imageURL: imageURL, backupImageData: nil, weather: weather)
                hourForecast.append(cast)
                let dateKey = date.getDayDesc(full: false)
                if !dates.contains(dateKey) { dates.append(dateKey)}
            }
        }
        for i in dates.indices {
            let daily = hourForecast.filter { $0.day.contains(dates[i]) }
            if let temp = daily.map({ $0.weather.temperatureInCelsium }).findAverage(),
               let iconID = daily.map({ $0.weather.iconID }).findMostRepeatableElement(),
               let url = URL(string: "http://openweathermap.org/img/wn/\(iconID)@2x.png"),
               let day = daily.first?.dayDescription,
               let humidity = daily.map({ $0.weather.humidity }).findAverage(),
               let visibility = daily.map({ $0.weather.visibility }).findAverage(),
               let windSpeed = daily.map({ $0.weather.windSpeed }).findAverage(),
               let weather = daily.map({ $0.weather.weather }).findMostRepeatableElement(){
                dailyForecast.append(Forecast(day: dates[i], dayDescription: day, imageURL: url, backupImageData: nil, weather: Weather(tempInKelvin: temp + 273, humidity: humidity, iconID: iconID, windSpeed: windSpeed, weather: weather, visibility: visibility)))
            }
        }
        completion(dailyForecast,hourForecast)
    }
    
}

/*
{
    list =     (
                {
            clouds =             {
                all = 66;
            };
            dt = 1606899600;
            "dt_txt" = "2020-12-02 09:00:00";
            main =             {
                "feels_like" = "266.31";
                "grnd_level" = 1019;
                humidity = 91;
                pressure = 1036;
                "sea_level" = 1036;
                temp = "270.53";
                "temp_kf" = "-0.24";
                "temp_max" = "270.77";
                "temp_min" = "270.53";
            };
            pop = 0;
            sys =             {
                pod = d;
            };
            visibility = 10000;
            weather =             (
                                {
                    description = "broken clouds";
                    icon = 04d;
                    id = 803;
                    main = Clouds;
                }
            );
            wind =             {
                deg = 136;
                speed = "2.47";
            };
        },
 
     */
