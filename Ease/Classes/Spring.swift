import Foundation
import QuartzCore
import Combine

public struct Spring<F: FloatingPoint> {
    
    let tension: F
    let damping: F
    let mass: F
    
    init(_ tension: F, _ damping: F, _ mass: F) {
        self.tension = tension
        self.damping = damping
        self.mass = mass
    }
}
