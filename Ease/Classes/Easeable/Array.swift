import Foundation

internal extension Array {
    
    func enumeratedMap<T>(_ transform: (Int, Element) -> T) -> [T] {
        var result: [T] = []
        result.reserveCapacity(count)
        
        for (index, element) in enumerated() {
            result.append(transform(index, element))
        }
        
        return result
    }
}

internal extension Array where Element: FloatingPoint {
    
    static func - (lhs: Self, rhs: Self) -> Self {
        lhs.enumeratedMap { $1 - rhs[$0] }
    }
    
    static func + (lhs: Self, rhs: Self) -> Self {
        lhs.enumeratedMap { $1 + rhs[$0] }
    }
    
    static func * (lhs: Self, rhs: Element) -> Self {
        lhs.map { $0 * rhs }
    }
    
    static func / (lhs: Self, rhs: Element) -> Self {
        lhs.map { $0 / rhs }
    }
    
    static func < (lhs: Self, rhs: Element) -> Bool {
        for value in lhs {
            if value < rhs {
                return true
            }
        }
        
        return false
    }
    
    static func > (lhs: Self, rhs: Element) -> Bool {
        for value in lhs {
            if value > rhs {
                return true
            }
        }
        
        return false
    }
}
