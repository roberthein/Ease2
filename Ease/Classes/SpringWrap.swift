import Foundation
import QuartzCore
import Combine

@available(iOS 13.0, *)
public final class SpringWrap<E: Easable> {
    
    @Published var value: E
    @Published var spring: Spring<E.F>
    
    var velocity: E = .zero
    var previousVelocity: E = .zero
    
    required init(_ value: E, _ tension: E.F, _ damping: E.F, _ mass: E.F) {
        self.value = value
        
        spring = Spring(tension, damping, mass)
    }
    
    func interpolate(to targetValue: E, duration: E.F) {
        let distance = value - targetValue
        let kx = distance * spring.tension
        let bv = velocity * spring.damping
        let acceleration = (kx + bv) / spring.mass
        
        previousVelocity = velocity
        velocity = velocity - (acceleration * duration)
        value = value + (velocity * duration)
    }
}
