import Foundation
import CoreGraphics

extension Array where Element: Hashable {
    
    func findMostRepeatableElement() -> Element? {
        if count == 0 { return nil }
        var count = [Element:Int]()
        forEach { count[$0] = (count[$0] ?? 0) + 1 }
        if let (value,_) = count.max(by: { $0.1 <= $1.1 }) {
            return value
        }
        return nil
    }
}


extension Array where Element: Numericable {
    
    func findAverage() -> Element? {
        if count == 0 { return nil }
        if count == 1 { return self.first! }
        return reduce(Element(0), {$0.value + $1.value })/Element(count)
    }
}



protocol Numericable {
    var value: Self { get }
    init(_ value : Int)
    static func *(lhs:Self,rhs:Self) -> Self
    static func +(lhs:Self,rhs:Self) -> Self
    static func -(lhs:Self,rhs:Self) -> Self
    static func /(lhs:Self,rhs:Self) -> Self
}


extension Double: Numericable {
    var value: Double { return self }
}

extension Int: Numericable {
    var value: Int { return self }
}


extension Float: Numericable {
    var value: Float { return self }
}

extension CGFloat: Numericable {
    var value: CGFloat { return self }
}


