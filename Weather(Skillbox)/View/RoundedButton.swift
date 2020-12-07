import UIKit

@IBDesignable
class RoundedButton: UIButton {

    @IBInspectable
    var color: UIColor = .red { didSet { setNeedsDisplay() }}
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath(roundedRect: rect, cornerRadius: 16)
        color.setFill()
        path.fill()      
    }

}
