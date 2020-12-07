import Foundation
import Alamofire


class WeatherFetcher_Alamofire {
    
    static func fetchWeather(completion: @escaping (Weather) -> Void ) {
        if let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?q=Moscow&lang=ru&appid=b86ba08e3b045016f8a7e08b97e64ad2") {
            AF.request(url).response { response in
                if let data = response.data, let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments),let dict = json as? [String:Any], let current = Weather(json: dict) {
                        DispatchQueue.main.async {
                        completion(current)
                    }
                        if let imageURL = URL(string: "http://openweathermap.org/img/wn/\(current.iconID)@2x.png")  {
                            ImageFetcher.fetch(imageURL)
                        }
                    }
            }
        }
    }
}


