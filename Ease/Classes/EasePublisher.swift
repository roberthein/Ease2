import Foundation
import QuartzCore
import Combine

@available(iOS 13.0, *)
public final class EasePublisher<E: Easable> {
    
    @Published var value: E
    @Published var spring: EaseSpring<E.F>
    
    var velocity: E = .zero
    var previousVelocity: E = .zero
    
    let rubberBandingRange: EaseRange<E>?
    let rubberBandingResilience: E.F?
    let clampingRange: EaseRange<E>?
    
    required init(_ value: E, _ tension: E.F, _ damping: E.F, _ mass: E.F, rubberBandingRange: EaseRange<E>? = nil, rubberBandingResilience: E.F? = nil, clampingRange: EaseRange<E>? = nil) {
        self.value = value
        self.rubberBandingRange = rubberBandingRange
        self.rubberBandingResilience = rubberBandingResilience
        self.clampingRange = clampingRange
        
        spring = EaseSpring(tension, damping, mass)
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
    
    func rubberBand() {
        if let range = rubberBandingRange, let resilience = rubberBandingResilience {
            let values: [E.F] = value.values.enumeratedMap {
                if let rubberBanded = value.rubberBanding(value: $1, range: range.closedRanges[$0], resilience: resilience) {
                    return rubberBanded
                } else {
                    return $1
                }
            }
            
            value.values = values
        }
    }
    
    func clamp() {
        if let range = clampingRange {
            let clampedValues: [E.F] = value.values.enumeratedMap {
                if let clampedValue = value.clamp(value: $1, range: range.closedRanges[$0]) {
                    self.velocity.values[$0] = self.velocity.values[$0] * -1
                    return clampedValue
                } else {
                    return $1
                }
            }
            
            value.values = clampedValues
        }
    }
}
