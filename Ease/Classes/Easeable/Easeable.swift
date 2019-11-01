import Foundation

public protocol Easable {
    associatedtype F: FloatingPoint
    static var zero: Self { get }
    var values: [F] { get set }
    init(with values: [F])
    static func float(from timeInterval: TimeInterval) -> F
}


internal extension Easable where F == Float {
    
    static func float(_ time: TimeInterval) -> Float {
        F(time)
    }
}
    
internal extension Easable {
    
    static func - (lhs: Self, rhs: Self) -> Self {
        return Self(with: lhs.values - rhs.values)
    }
    
    static func + (lhs: Self, rhs: Self) -> Self {
        return Self(with: lhs.values + rhs.values)
    }
    
    static func * (lhs: Self, rhs: Self.F) -> Self {
        return Self(with: lhs.values * rhs)
    }
    
    static func / (lhs: Self, rhs: Self.F) -> Self {
        return Self(with: lhs.values / rhs)
    }
    
    static func < (lhs: Self, rhs: Self.F) -> Bool {
        return lhs.values < rhs
    }
    
    static func > (lhs: Self, rhs: Self.F) -> Bool {
        return lhs.values > rhs
    }
    
    func clamp(value: Self.F, range: ClosedRange<Self.F>) -> Self.F? {
        
        if value < range.lowerBound {
            return range.lowerBound
        } else if value > range.upperBound {
            return range.upperBound
        }
        
        return nil
    }
    
    func rubberBanding(value: Self.F, range: ClosedRange<Self.F>, stiffness: Self.F) -> Self.F? {
        
        if value > range.upperBound {
            let offset = abs(range.upperBound - value) / stiffness
            return range.upperBound + offset
        } else if value < range.lowerBound {
            let offset = abs(range.lowerBound - value) / stiffness
            return range.lowerBound - offset
        }
        
        return nil
    }
    
    func set(_ value: Self.F) -> Self {
        return Self(with: values.map { _ in value })
    }
}
