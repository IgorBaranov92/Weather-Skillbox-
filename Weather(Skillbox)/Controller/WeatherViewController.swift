import UIKit

class WeatherViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, WeatherViewDelegate, CurrentWeatherDelegate {

    @IBOutlet weak var forecastSpinner: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containerView: UIView! { didSet {
        containerView.isHidden = true
        containerView.alpha = 0.7
    }}
    
    @IBOutlet weak var forecastChooser: UISegmentedControl!
    
    private var forecastData: ForecastData!
    
    private var weatherView = WeatherView()
    private var index = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        recreateForecastIfPossible()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let index = tabBarController?.selectedIndex {
            if index == 0 { // native
                ForecastFetcher.fetchWeather { [weak self] (daily,hour) in
                    self?.update(daily, hour)
                }
            } else { //Alamofire
                ForecastFetcher_Alamofire.fetchWeather{ [weak self] (daily,hour) in
                    self?.update(daily, hour)
                }
            }
        }
    }
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastData?.currentForecast.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell", for: indexPath)
        if let weatherCell = cell as? WeatherTableViewCell {
            if let foreCastData = forecastData {
                let forecast = foreCastData.currentForecast
                weatherCell.dateDescriptionLabel.text = forecast[indexPath.row].dayDescription
                weatherCell.dateLabel.text = forecast[indexPath.row].day
                let temperature = index == 0 ? "\(forecast[indexPath.row].weather.temperatureInCelsium)°C" : "\(forecast[indexPath.row].weather.temperatureInFahrenheit)°F"
                weatherCell.tempLabel.text = "\(temperature)"
                weatherCell.fetch(forecast[indexPath.row].imageURL, backupData: forecast[indexPath.row].backupImageData) { [unowned weatherCell](url, data) in
                    if url == forecast[indexPath.row].imageURL {
                        self.forecastData.updateBackupDataAt(indexPath.row, backup: data)
                        weatherCell.weatherImageView.image = UIImage(data: data)
                        self.saveForecast()
                    }
                }
            }

            return weatherCell
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        weatherView = WeatherView.initFromNib()
        weatherView.delegate = self
        containerView.isHidden = false
        view.addSubview(weatherView)
        updateWeatherAt(index: indexPath.row)
        WeatherViewConstraint.activate(weatherView, self.view)
        WeatherAnimator.show(weatherView)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Прогноз"
    }
  
    
    func resingFirstResponder() {
        WeatherAnimator.dismiss(weatherView) {
            self.weatherView.removeFromSuperview()
            self.containerView.isHidden = true
        }
    }
    
    private func updateWeatherAt(index:Int) {
        weatherView.updateUIWith(forecastData.currentForecast[index])
    }
    
    
    @IBAction func forecastChoose(_ sender: UISegmentedControl) {
        forecastData.type = sender.selectedSegmentIndex == 0 ? .daily : .hour
        tableView.reloadData()
    }
    
    func chooserSelectedAt(index: Int) {
        if forecastData != nil {
            self.index = index
            tableView.reloadData()
        }
    }
    
    private var childVC: CurrentWeatherViewController?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CurrentWeather",let destination = segue.destination as? CurrentWeatherViewController {
            childVC = destination
            childVC?.delegate = self
        }
    }
    
    private func update(_ daily:[Forecast],_ hour:[Forecast]) {
        forecastData = ForecastData()
        forecastData.update(daily: daily, hour: hour)
        saveForecast()
        tableView.reloadData()
        forecastSpinner.stopAnimating()
    }
    
    private func recreateForecastIfPossible() {
        if let url = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("forecast"),let data = try? Data(contentsOf: url),let newValue = ForecastData(json: data) {
            forecastData = newValue
            tableView.reloadData()
            saveForecast()
        }
    }
    
    private func saveForecast() {
        if let urlToSave = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("forecast"),let json = forecastData.json {
            try? json.write(to: urlToSave)
        }
    }
    
    
}


extension WeatherView {
    
    func updateUIWith(_ forecast:Forecast) {
        let weather = forecast.weather
        humidityLabel.text = "Влажность: \(weather.humidity)%"
        visibilityLabel.text = "Видимость: \(weather.visibility.trimmed)км"
        windLabel.text = "Ветер: \(weather.windSpeed)м/с"
        dateLabel.text = "\(forecast.dayDescription) \(forecast.day) "
        tempLabel.text = "\(weather.weather.capitalizedFirst) \(weather.temperatureInCelsium)°C/\(weather.temperatureInFahrenheit)°F"
    }
}
