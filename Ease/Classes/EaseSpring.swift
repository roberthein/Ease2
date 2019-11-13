import Foundation
import Combine

public struct EaseSpring<E: Easable> {

    let tension: E.Scalar
    let damping: E.Scalar
    let mass: E.Scalar
    
    var velocity: E = .zero
    var previousVelocity: E = .zero

    public init(_ tension: E.Scalar, _ damping: E.Scalar, _ mass: E.Scalar) {
        self.tension = tension
        self.damping = damping
        self.mass = mass
    }
}
