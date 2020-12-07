import UIKit

class WeatherAnimator {
    
    static func show(_ view:UIView) {
        view.alpha = 0
        view.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.3,
            delay: 0.0,
            options: .curveLinear,
            animations: {
                view.transform = CGAffineTransform.identity
                view.alpha = 1.0
        })
    }
    
    static func dismiss(_ view:UIView,_ completion:( () -> () )? = nil ) {
        UIViewPropertyAnimator.runningPropertyAnimator(
            withDuration: 0.3,
                   delay: 0.0,
                   options: .curveLinear,
                   animations: {
                       view.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
                       view.alpha = 0.0
               }) {  if $0 == .end { completion?() }
               }
    }
    
    
}
