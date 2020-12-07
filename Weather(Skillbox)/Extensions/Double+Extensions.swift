import Foundation


extension Double {
    var trimmed: String {
        if self.truncatingRemainder(dividingBy: 1) == 0 {
            return String(Int(self))
        } else {
            return String(format: "%.1f", self)
        }
    }
}
