import UIKit

protocol WeatherViewDelegate: class {
    func resingFirstResponder()
}

class WeatherView: UIView {

    weak var delegate: WeatherViewDelegate?
    
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var visibilityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    
    @IBAction func dismiss(_ sender: RoundedButton) {
        delegate?.resingFirstResponder()
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(roundedRect: rect.insetBy(dx: 3.0, dy: 3.0), cornerRadius: 16)
        UIColor.white.setFill()
        path.fill()
        path.lineWidth = 1
        #colorLiteral(red: 0.2355433221, green: 0.6295864996, blue: 1, alpha: 1).setStroke()
        path.stroke()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .clear
    }
    
}
