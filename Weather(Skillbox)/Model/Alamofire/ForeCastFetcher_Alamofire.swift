import Foundation
import Alamofire

class ForecastFetcher_Alamofire {
    
    static func fetchWeather(completion: @escaping ([Forecast],[Forecast]) -> Void ) {
        DispatchQueue.global(qos: .userInitiated).async {
            if let url = URL(string: "http://api.openweathermap.org/data/2.5/forecast?q=Moscow&lang=ru&appid=b86ba08e3b045016f8a7e08b97e64ad2") {
                AF.request(url).response { (response) in
                    if let data = response.data,
                       let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) {
                        if let dict = json as? [String:Any],let list = dict["list"] as? [[String:Any]] {
                            ForecastParser.parse(json: list) { daily,hour in
                                DispatchQueue.main.async {
                                    completion(daily,hour)
                                }
                            }
                        }
                    }
                    
                }

            }
        }
    }
    
}
