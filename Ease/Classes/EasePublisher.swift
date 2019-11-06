import Foundation
import QuartzCore
import Combine






@available(iOS 13.0, *)
public class ESubscription<SubscriberType: Subscriber, E: Easable>: Subscription where SubscriberType.Input == E {
    
    var subscriber: SubscriberType?
//    var value: E
//    var spring: EaseSpring<E.F>
    
    init(subscriber: SubscriberType, value: E, spring: EaseSpring<E.F>) {
        self.subscriber = subscriber
//        self.value = value
//        self.spring = spring
    }
    
    public func request(_ demand: Subscribers.Demand) {
        // We do nothing here as we only want to send events when they occur.
        // See, for more info: https://developer.apple.com/documentation/combine/subscribers/demand
    }
    
    public func cancel() {
        subscriber = nil
    }
    
//    @objc private func eventHandler() {
//        _ = subscriber?.receive(value)
//    }
}

@available(iOS 13.0, *)
public struct EPublisher<E: Easable>: Publisher {
    
    public typealias Output = E
    public typealias Failure = Never
    
    var value: E
    var spring: EaseSpring<E.F>
    
    var velocity: E = .zero
    var previousVelocity: E = .zero
    
    let rubberBandingRange: EaseRange<E>?
    let rubberBandingResilience: E.F?
    let clampingRange: EaseRange<E>?
    
    init(_ value: E, _ tension: E.F, _ damping: E.F, _ mass: E.F, rubberBandingRange: EaseRange<E>? = nil, rubberBandingResilience: E.F? = nil, clampingRange: EaseRange<E>? = nil) {
        self.value = value
        self.rubberBandingRange = rubberBandingRange
        self.rubberBandingResilience = rubberBandingResilience
        self.clampingRange = clampingRange
        
        spring = EaseSpring(tension, damping, mass)
    }
    
    public func receive<S>(subscriber: S) where S : Subscriber, S.Failure == EPublisher.Failure, S.Input == EPublisher.Output {
        let subscription = ESubscription(subscriber: subscriber, value: value, spring: spring)
        subscriber.receive(subscription: subscription)
    }
    
    mutating func update(_ targetValue: E, _ duration: E.F) {
        interpolate(to: targetValue, duration: duration)
        rubberBand()
        clamp()
    }
    
    private mutating func interpolate(to targetValue: E, duration: E.F) {
        let distance = value - targetValue
        let kx = distance * spring.tension
        let bv = velocity * spring.damping
        let acceleration = (kx + bv) / spring.mass
        
        previousVelocity = velocity
        velocity = velocity - (acceleration * duration)
        value = value + (velocity * duration)
    }
    
    private mutating func rubberBand() {
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
    
    private mutating func clamp() {
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





//@available(iOS 13.0, *)
//public extension Ease {
//    
//    struct Publisher<E: Easable>: Combine.Publisher {
//        public typealias Output = E
//        public typealias Failure = Never
//        
//    }
//}
//
//@available(iOS 13.0, *)
//extension Subscribers {
//    
//    class Assign<Root, Input>: Subscriber, Cancellable {
//        typealias Failure = Never
//        
//        init(object: Root, keyPath: ReferenceWritableKeyPath<Root, Input>) {
//            
//        }
//    }
//}


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
    
    func update(_ targetValue: E, _ duration: E.F) {
        interpolate(to: targetValue, duration: duration)
        rubberBand()
        clamp()
    }
    
    private func interpolate(to targetValue: E, duration: E.F) {
        let distance = value - targetValue
        let kx = distance * spring.tension
        let bv = velocity * spring.damping
        let acceleration = (kx + bv) / spring.mass
        
        previousVelocity = velocity
        velocity = velocity - (acceleration * duration)
        value = value + (velocity * duration)
    }
    
    private func rubberBand() {
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
    
    private func clamp() {
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
