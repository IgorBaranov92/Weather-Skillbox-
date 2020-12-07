import Foundation


class WeatherFetcher :Fetcher {
    
    override func fetchWeather(completion: @escaping (Weather) -> Void ) {
        DispatchQueue.global(qos: .userInitiated).async {
            if let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?q=Moscow&lang=ru&appid=b86ba08e3b045016f8a7e08b97e64ad2") {
                URLSession.shared.dataTask(with: url) { (data, responce, error) in
                    if let data = data,
                       let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
                        if let dict = json as? [String:Any] {
                            if let current = Weather(json: dict) {
                                let imageURL = URL(string: "http://openweathermap.org/img/wn/\(current.iconID)@2x.png")
                                    ImageFetcher.fetch(imageURL)
                                DispatchQueue.main.async {
                                    completion(current)
                                }
                            } else { print("can't create weather object")}
                        }
                    }
                }.resume()
            }
        }
    }
}


