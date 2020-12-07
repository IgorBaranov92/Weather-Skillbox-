import UIKit


extension UIView {
    class func initFromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)!.first as! T
    }
}
