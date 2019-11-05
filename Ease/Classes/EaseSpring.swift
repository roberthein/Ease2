import Foundation
import QuartzCore
import Combine

public struct EaseSpring<F: FloatingPoint> {
    
    let tension: F
    let damping: F
    let mass: F
    
    public init(_ tension: F, _ damping: F, _ mass: F) {
        self.tension = tension
        self.damping = damping
        self.mass = mass
    }
}
