import Foundation
import UIKit

class WeatherViewConstraint {
    
    class func activate(_ v1: UIView,_ v2: UIView) {
        v1.translatesAutoresizingMaskIntoConstraints = false
        v1.centerXAnchor.constraint(equalTo: v2.centerXAnchor).isActive = true
        v1.centerYAnchor.constraint(equalTo: v2.centerYAnchor).isActive = true
        let width = v2.bounds.width - 20
        v1.widthAnchor.constraint(equalToConstant: width).isActive = true
        v1.heightAnchor.constraint(equalToConstant: width).isActive = true
    }
    
}
