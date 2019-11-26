import Foundation

public enum EaseDecelerationRate: Float {
    case slow   = 0.5
    case normal = 0.8
    case fast   = 0.95
}

public enum EaseVelocityJump: Float {
    case small  = 0.0005
    case normal = 0.001
    case big    = 0.005
}

public struct EaseBehavior<E: Easable, N: NSObject> {
    
    public var tension: E.Scalar
    public var damping: E.Scalar
    public var mass: E.Scalar
    public var decelerationRate: EaseDecelerationRate = .normal
    public var velocityJump: EaseVelocityJump = .normal
    public var rubberBandRange: EaseRange<E>? = nil
    public var resilience: E.Scalar = 1
    public var clampRange: EaseRange<E>? = nil
    public var keyPath: ReferenceWritableKeyPath<N, E>
    public var targets: [E]?
    
    public init(tension: E.Scalar, damping: E.Scalar, mass: E.Scalar, decelerationRate: EaseDecelerationRate = .normal, velocityJump: EaseVelocityJump = .normal, rubberBandRange: EaseRange<E>? = nil, resilience: E.Scalar = 1, clampRange: EaseRange<E>? = nil, keyPath: ReferenceWritableKeyPath<N, E>, targets: [E]? = nil) {
        self.tension = tension
        self.damping = damping
        self.mass = mass
        self.decelerationRate = decelerationRate
        self.velocityJump = velocityJump
        self.rubberBandRange = rubberBandRange
        self.resilience = resilience
        self.clampRange = clampRange
        self.keyPath = keyPath
        self.targets = targets
    }
}
