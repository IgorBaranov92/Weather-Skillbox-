import UIKit

protocol CurrentWeatherDelegate: class {
    func chooserSelectedAt(index:Int)
}

class CurrentWeatherViewController: UIViewController, ImageFetcherDelegate {

    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var weatherChooser: UISegmentedControl!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var visibilityLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    
    var weather: Weather!
    weak var delegate: CurrentWeatherDelegate?
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let index = tabBarController?.selectedIndex, weather == nil {
            if index == 0 { // native
                ImageFetcher.delegate = self
                WeatherFetcher.fetchWeather { [weak self] (currentWeather) in
                    self?.weather = currentWeather
                    self?.updateUI()
                }
            } else { //Alamofire
                ImageFetcher_Alamofire.delegate = self
                WeatherFetcher_Alamofire.fetchWeather { [weak self] (currentWeather) in
                    self?.weather = currentWeather
                    self?.updateUI()
                }
            }
        }
    }
    
    func imageFetched(_ image: UIImage) {
        imageView.image = image
    }

    
    private func updateUI() {
        spinner.stopAnimating()
        humidityLabel.text = "Влажность: \(weather.humidity)%"
        weatherLabel.text = weather.weather
        sunsetLabel.text = "Закат: \(weather.sunset)"
        visibilityLabel.text = "Видимость: \(weather.visibility.trimmed)км"
        windLabel.text = "Ветер: \(weather.windSpeed)м/с"
        updateTemperature()
    }
    
    @IBAction func temperatureChanged(_ sender:UISegmentedControl) {
        if weather != nil { updateTemperature() }
        delegate?.chooserSelectedAt(index: sender.selectedSegmentIndex)
    }
    
    private func updateTemperature() {
        let temperature = weatherChooser.selectedSegmentIndex == 0 ? "\(weather.temperatureInCelsium)°C" : "\(weather.temperatureInFahrenheit)°F"
        weatherLabel.text = "\(weather.weather.capitalizedFirst) \(temperature)"
    }
    
}
