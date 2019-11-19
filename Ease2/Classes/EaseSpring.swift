import Foundation
import Combine

public struct EaseSpring<E: Easable> {

    let tension: E.Scalar
    let damping: E.Scalar
    let mass: E.Scalar
    
    var velocity: E = .zero
    var previousValue: E
    var previousPreviousValue: E

    public init(_ tension: E.Scalar, _ damping: E.Scalar, _ mass: E.Scalar, _ previousValue: E) {
        self.tension = tension
        self.damping = damping
        self.mass = mass
        self.previousValue = previousValue
        self.previousPreviousValue = previousValue
    }
    
    func shouldPause(_ value: E, _ targetValue: E, _ minimumStep: E.Scalar) -> Bool {
        let closeToTarget = abs(value.distance(to: targetValue)) < minimumStep
        let wasCloseToTarget = abs(previousValue.distance(to: targetValue)) < minimumStep
        let wasWasCloseToTarget = abs(previousPreviousValue.distance(to: targetValue)) < minimumStep
        
        return closeToTarget && wasCloseToTarget && wasWasCloseToTarget
    }
}
