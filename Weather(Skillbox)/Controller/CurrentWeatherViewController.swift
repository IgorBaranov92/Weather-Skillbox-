import UIKit

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
    
    var weather: Weather! { didSet { saveWeather() }}
    
    weak var delegate: CurrentWeatherDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recreateWeatherIfPossible()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let index = tabBarController?.selectedIndex {
            ImageFetcher.delegate = self
            if index == 0 { // native
                fetchWith(WeatherFetcher())
            } else { //Alamofire
                fetchWith(WeatherFetcher_Alamofire())
            }
        }
    }
    
    private func fetchWith(_ fetcher:Fetcher) {
        fetcher.fetchWeather { [weak self] (currentWeather) in
            self?.weather = currentWeather
            self?.updateUI(shouldHideSpinner: true)            
        }
    }
    
    func imageFetched(_ image: UIImage,backup:Data?) {
        imageView.image = image
        weather.backupImageData = backup
    }

    
    private func updateUI(shouldHideSpinner:Bool) {
        if shouldHideSpinner { spinner.stopAnimating() }
        if weather != nil, let backup = weather.backupImageData {
            imageView.image = UIImage(data: backup)
        }
        humidityLabel.text = "Влажность: \(weather.humidity)%"
        visibilityLabel.text = "Видимость: \(weather.visibility.trimmed)км"
        windLabel.text = "Ветер: \(weather.windSpeed)м/с"
        weatherLabel.text = weather.weather
        sunsetLabel.text = "Закат: \(weather.sunset)"
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
    
    private func saveWeather() {
        if let urlToSave = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("weather"),let json = weather.json {
            try? json.write(to: urlToSave)
        }
    }
    
    private func recreateWeatherIfPossible() {
        if let url = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("weather"),let data = try? Data(contentsOf: url),let newValue = Weather(json: data) {
            weather = newValue
            updateUI(shouldHideSpinner: false)
            saveWeather()
        }
    }
    
    
}
