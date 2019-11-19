import Foundation

//MARK: - The Protocol

/// A protocol to homogenize value types that are 'Easable'.
public protocol Easable {
    
    associatedtype Scalar: FloatingPoint
    
    var scalars: [Scalar] { get set }
    
    static var zero: Self { get }
    
    subscript(index: Int) -> Scalar { get set }
    
    static func new(_ scalars: [Scalar]) -> Self
    
    static func scalar(_ scalar: Float) -> Scalar
}

//MARK: - Defaults

/// The default implementations for the 'Easable' protocol.
public extension Easable {
    
    subscript(index: Int) -> Scalar {
        get { return scalars[index] }
        set { scalars[index] = newValue }
    }
    
    static func new(_ scalars: [Scalar]) -> Self {
        var new: Self = .zero
        new.scalars = scalars
        
        return new
    }
}

//MARK: - Operator Overloading

/// Operator overloading for calculations between 'Easables' and/or 'Scalars'.
internal extension Easable {
    
    static func - (lhs: Self, rhs: Self) -> Self { .new(lhs.scalars.enumerated().map { $1 - rhs.scalars[$0] }) }
    
    static func + (lhs: Self, rhs: Self) -> Self { .new(lhs.scalars.enumerated().map { $1 + rhs.scalars[$0] }) }
    
    static func * (lhs: Self, rhs: Scalar) -> Self { .new(lhs.scalars.map { $0 * rhs }) }
    
    static func / (lhs: Self, rhs: Scalar) -> Self { .new(lhs.scalars.map { $0 / rhs }) }
    
    static func < (lhs: Self, rhs: Scalar) -> Bool { (lhs.scalars.map { $0 < rhs }).contains(true) }
    
    static func > (lhs: Self, rhs: Scalar) -> Bool { (lhs.scalars.map { $0 > rhs }).contains(true) }
    
    static func == (lhs: Self, rhs: Self) -> Bool { (lhs.scalars.enumerated().map { $1 == rhs.scalars[$0] }).contains(false) == false }
}

//MARK: - Linear Interpolation

/// Add linear interpolation between two 'Easable' objects.
internal extension Easable {
    
    func lerp(target: Self, spring: inout EaseSpring<Self>, duration: Scalar) -> Self {
        spring.previousPreviousValue = spring.previousValue
        spring.previousValue = self
        
        let distance = self - target
        let kx = distance * spring.tension
        let bv = spring.velocity * spring.damping
        let acceleration = (kx + bv) / spring.mass
        
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
    
    private func clamped(value: Scalar, range: ClosedRange<Scalar>) -> Scalar {
        
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
    
    func rubberBand(in range: EaseRange<Self>, with resilience: Scalar) -> Self {
        .new(scalars.enumerated().map { rubberBanded(value: $1, in: range.closedRanges[$0], with: resilience) })
    }
    
    private func rubberBanded(value: Scalar, in range: ClosedRange<Scalar>, with resilience: Scalar) -> Scalar {
        
        if value > range.upperBound {
            return range.upperBound + (abs(range.upperBound - value) / resilience)
        } else if value < range.lowerBound {
            return range.lowerBound - (abs(range.lowerBound - value) / resilience)
        }
        
        return value
    }
}

//MARK: - Distance

/// Calculate the distance between two 'Easable' objects.
internal extension Easable {
    
    private func sq(_ value: Scalar) -> Scalar {
        return value * value
    }
    
    func distance(to target: Self) -> Scalar {
        return sqrt(scalars.enumerated().map { (arg) -> Scalar in
            let (i, scalar) = arg
            return sq(scalar - target.scalars[i])
        }.reduce(0, +))
    }
}
