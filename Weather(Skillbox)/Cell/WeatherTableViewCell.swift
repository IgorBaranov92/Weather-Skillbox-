import UIKit

class WeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dateDescriptionLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    func fetch(_ url:URL?,backupData:Data?,completion: ((URL,Data) -> Void)? = nil) {
        
        if backupData != nil {
            weatherImageView.image = UIImage(data: backupData!)
            spinner?.stopAnimating()
        } else if let url = url {
            DispatchQueue.global(qos: .userInitiated).async {
                if let imageData = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        completion?(url,imageData)
                        self.spinner.stopAnimating()
                    }
                }
            }
        }
    }

}
