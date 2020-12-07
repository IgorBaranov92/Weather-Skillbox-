import UIKit

class WeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var weatherImageView: UIImageView! { didSet {
        spinner?.stopAnimating()
    }}
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dateDescriptionLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    func fetch(_ url:URL?,backupData:Data?,completion: ((URL,Data) -> Void)? = nil) {
        if backupData != nil {
            weatherImageView.image = UIImage(data: backupData!)
        } else {
            ImageFetcher.fetch(url, backupData: nil) { [unowned self] (foundURL, data) in
                if url == foundURL {
                    self.weatherImageView.image = UIImage(data: data)
                    completion?(foundURL,data)
                }
            }
        }
    }

}
