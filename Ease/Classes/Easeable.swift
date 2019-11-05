import Foundation
import CoreGraphics

public protocol Easable {
    associatedtype F: FloatingPoint
    static var zero: Self { get }
    var values: [F] { get set }
    init(with values: [F])
}
    
internal extension Easable {
    
    static func - (lhs: Self, rhs: Self) -> Self {
        Self(with: lhs.values - rhs.values)
    }
    
    static func + (lhs: Self, rhs: Self) -> Self {
        Self(with: lhs.values + rhs.values)
    }
    
    static func * (lhs: Self, rhs: Self.F) -> Self {
        Self(with: lhs.values * rhs)
    }
    
    static func / (lhs: Self, rhs: Self.F) -> Self {
        Self(with: lhs.values / rhs)
    }
    
    static func < (lhs: Self, rhs: Self.F) -> Bool {
        lhs.values < rhs
    }
    
    static func > (lhs: Self, rhs: Self.F) -> Bool {
        lhs.values > rhs
    }
    
    func clamp(value: Self.F, range: ClosedRange<Self.F>) -> Self.F? {
        
        if value < range.lowerBound {
            return range.lowerBound
        } else if value > range.upperBound {
            return range.upperBound
        }
        
        return nil
    }
    
    func rubberBanding(value: Self.F, range: ClosedRange<Self.F>, resilience: Self.F) -> Self.F? {
        
        if value > range.upperBound {
            let offset = abs(range.upperBound - value) / resilience
            return range.upperBound + offset
        } else if value < range.lowerBound {
            let offset = abs(range.lowerBound - value) / resilience
            return range.lowerBound - offset
        }
        
        return nil
    }
    
    func set(_ value: Self.F) -> Self {
        Self(with: values.map { _ in value })
    }
}
