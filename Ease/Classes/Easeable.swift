import Foundation

//MARK: - The Protocol

/// A protocol to homogenize value types that are 'Easable'.
public protocol Easable {
    
    associatedtype Scalar: FloatingPoint
    
    var scalars: [Scalar] { get set }
    
    static var zero: Self { get }
    
    subscript(index: Int) -> Scalar { get set }
    
    static func new(_ scalars: [Scalar]) -> Self
}

//MARK: - Defaults

/// The default implementations for the 'Easable' protocol.
extension Easable {
    
    public subscript(index: Int) -> Scalar {
        get { return scalars[index] }
        set { scalars[index] = newValue }
    }
    
    public static func new(_ scalars: [Scalar]) -> Self {
        var new: Self = .zero
        new.scalars = scalars
        
        return new
    }
}

//MARK: - Operator Overloading

/// Operator overloading for calculations between 'Easables' and 'Scalars'.
internal extension Easable {
    
    static func - (lhs: Self, rhs: Self) -> Self { .new(lhs.scalars.enumerated().map { $1 - rhs.scalars[$0] }) }
    
    static func + (lhs: Self, rhs: Self) -> Self { .new(lhs.scalars.enumerated().map { $1 + rhs.scalars[$0] }) }
    
    static func * (lhs: Self, rhs: Self.Scalar) -> Self { .new(lhs.scalars.map { $0 * rhs }) }
    
    static func / (lhs: Self, rhs: Self.Scalar) -> Self { .new(lhs.scalars.map { $0 / rhs }) }
    
    static func < (lhs: Self, rhs: Self.Scalar) -> Bool { (lhs.scalars.map { $0 < rhs }).contains(true) }
    
    static func > (lhs: Self, rhs: Self.Scalar) -> Bool { (lhs.scalars.map { $0 > rhs }).contains(true) }
}

//MARK: - Linear Interpolation

/// Add linear interpolation between two 'Easable' objects.
internal extension Easable {
    
    func lerp(target: Self, spring: inout EaseSpring<Self>, duration: Self.Scalar) -> Self {
        let distance = self - target
        let kx = distance * spring.tension
        let bv = spring.velocity * spring.damping
        let acceleration = (kx + bv) / spring.mass
        
        spring.previousVelocity = spring.velocity
        spring.velocity = spring.velocity - (acceleration * duration)
        
        return self + (spring.velocity * duration)
    }
}

//MARK: - Clamping

/// Add clamping for 'Easable' objects.
internal extension Easable {
    
    func clamp(range: EaseRange<Self>) -> Self {
        .new(scalars.enumerated().map { clamped(value: $1, range: range.closedRanges[$0]) })
    }
    
    private func clamped(value: Self.Scalar, range: ClosedRange<Self.Scalar>) -> Self.Scalar {
        
        if self < range.lowerBound {
            return range.lowerBound
        } else if self > range.upperBound {
            return range.upperBound
        }
        
        return value
    }
}

//MARK: - Rubber Banding

/// Add rubber banding for 'Easable' objects.
internal extension Easable {
    
    func rubberBand(in range: EaseRange<Self>, with resilience: Self.Scalar) -> Self {
        .new(scalars.enumerated().map { rubberBanded(value: $1, in: range.closedRanges[$0], with: resilience) })
    }
    
    private func rubberBanded(value: Self.Scalar, in range: ClosedRange<Self.Scalar>, with resilience: Self.Scalar) -> Self.Scalar {
        
        if value > range.upperBound {
            return range.upperBound + (abs(range.upperBound - value) / resilience)
        } else if value < range.lowerBound {
            return range.lowerBound - (abs(range.lowerBound - value) / resilience)
        }
        
        return value
    }
}
