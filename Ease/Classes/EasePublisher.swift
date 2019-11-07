import Foundation
import QuartzCore
import Combine






//@available(iOS 13.0, *)
//public class ESubscription<S: Subscriber, E: Easable>: Subscription where S.Input == E {
//
//    var subscriber: S?
////    var value: E
////    var spring: EaseSpring<E.F>
//
//    init(subscriber: S, value: E, spring: EaseSpring<E.F>) {
//        self.subscriber = subscriber
////        self.value = value
////        self.spring = spring
//    }
//
//    public func request(_ demand: Subscribers.Demand) {
//        // We do nothing here as we only want to send events when they occur.
//        // See, for more info: https://developer.apple.com/documentation/combine/subscribers/demand
//    }
//
//    public func cancel() {
//        subscriber = nil
//    }
//
////    @objc private func eventHandler() {
////        _ = subscriber?.receive(value)
////    }
//}

//@available(iOS 13.0, *)
//public struct EPublisher<E: Easable>: Publisher {
//
//    public typealias Output = E
//    public typealias Failure = Never
//
//    var value: E
//    var spring: EaseSpring<E.F>
//
//    var velocity: E = .zero
//    var previousVelocity: E = .zero
//
//    let rubberBandingRange: EaseRange<E>?
//    let rubberBandingResilience: E.F?
//    let clampingRange: EaseRange<E>?
//
//    init(_ value: E, _ tension: E.F, _ damping: E.F, _ mass: E.F, rubberBandingRange: EaseRange<E>? = nil, rubberBandingResilience: E.F? = nil, clampingRange: EaseRange<E>? = nil) {
//        self.value = value
//        self.rubberBandingRange = rubberBandingRange
//        self.rubberBandingResilience = rubberBandingResilience
//        self.clampingRange = clampingRange
//
//        spring = EaseSpring(tension, damping, mass)
//    }
//
//    public func receive<S>(subscriber: S) where S : Subscriber, S.Failure == Failure, S.Input == Output {
//        let subscription = ESubscription(subscriber: subscriber, value: value, spring: spring)
//        subscription.subscriber
//        subscriber.receive(subscription: subscription)
//    }
//
//    mutating func update(_ targetValue: E, _ duration: E.F) {
//        interpolate(to: targetValue, duration: duration)
//        rubberBand()
//        clamp()
//    }
//
//    private mutating func interpolate(to targetValue: E, duration: E.F) {
//        let distance = value - targetValue
//        let kx = distance * spring.tension
//        let bv = velocity * spring.damping
//        let acceleration = (kx + bv) / spring.mass
//
//        previousVelocity = velocity
//        velocity = velocity - (acceleration * duration)
//        value = value + (velocity * duration)
//    }
//
//    private mutating func rubberBand() {
//        if let range = rubberBandingRange, let resilience = rubberBandingResilience {
//            let values: [E.F] = value.values.enumeratedMap {
//                if let rubberBanded = value.rubberBanding(value: $1, range: range.closedRanges[$0], resilience: resilience) {
//                    return rubberBanded
//                } else {
//                    return $1
//                }
//            }
//
//            value.values = values
//        }
//    }
//
//    private mutating func clamp() {
//        if let range = clampingRange {
//            let clampedValues: [E.F] = value.values.enumeratedMap {
//                if let clampedValue = value.clamp(value: $1, range: range.closedRanges[$0]) {
//                    self.velocity.values[$0] = self.velocity.values[$0] * -1
//                    return clampedValue
//                } else {
//                    return $1
//                }
//            }
//
//            value.values = clampedValues
//        }
//    }
//}


@available(iOS 13.0, *)

public struct ESubscription<Content: SubscriptionBehavior>: Subscriber, Subscription {
    public typealias Input = Content.Input
    public typealias Failure = Content.Failure
    
    public var combineIdentifier: CombineIdentifier { return content.combineIdentifier }
    let recursiveMutex = NSRecursiveLock()
    let content: Content
    
    init(behavior: Content) {
        self.content = behavior
    }
    
    public func request(_ demand: Subscribers.Demand) {
        recursiveMutex.lock()
        defer { recursiveMutex.unlock() }
        content.request(demand)
    }
    
    public func cancel() {
        recursiveMutex.lock()
        content.cancel()
        recursiveMutex.unlock()
    }
    
    public func receive(subscription upstream: Subscription) {
        recursiveMutex.lock()
        defer { recursiveMutex.unlock() }
        content.upstream = upstream
        content.downstream.receive(subscription: self)
    }
    
    public func receive(_ input: Input) -> Subscribers.Demand {
        recursiveMutex.lock()
        defer { recursiveMutex.unlock() }
        return content.receive(input)
    }
    
    public func receive(completion: Subscribers.Completion<Failure>) {
        recursiveMutex.lock()
        defer { recursiveMutex.unlock() }
        content.receive(completion: completion)
    }
}


@available(iOS 13.0, *)
public class EPublisher<Output: Easable, Failure: Error>: Subject, Publisher {
    
    class Behavior: SubscriptionBehavior {
        typealias Input = Output
        
        var upstream: Subscription? = nil
        let downstream: AnySubscriber<Input, Failure>
        let subject: EPublisher<Output, Failure>
        var demand: Subscribers.Demand = .none
        
        init(subject: EPublisher<Output, Failure>, downstream: AnySubscriber<Input, Failure>) {
            self.downstream = downstream
            self.subject = subject
        }
        
        func request(_ d: Subscribers.Demand) {
            demand += d
            upstream?.request(d)
        }
        
        func cancel() {
            subject.subscribers.mutate { subs in subs.removeValue(forKey: combineIdentifier) }
        }
    }
    
    let subscribers = AtomicBox<Dictionary<CombineIdentifier, ESubscription<Behavior>>>([:])
    
    var value: Output
    let spring: EaseSpring<Output.F>
    
    var velocity: Output = .zero
    var previousVelocity: Output = .zero
    
    public init(value: Output, spring: EaseSpring<Output.F>) {
        self.value = value
        self.spring = spring
    }
    
    public func update(_ targetValue: Output, _ duration: Output.F) {
        interpolate(to: targetValue, duration: duration)
        send(value)
    }
    
    private func interpolate(to targetValue: Output, duration: Output.F) {
        let distance = value - targetValue
        let kx = distance * spring.tension
        let bv = velocity * spring.damping
        let acceleration = (kx + bv) / spring.mass
        
        previousVelocity = velocity
        velocity = velocity - (acceleration * duration)
        value = value + (velocity * duration)
    }
    
    public func send(_ value: Output) {
        for (_, sub) in subscribers.value {
            _ = sub.receive(value)
        }
    }
    
    public func send(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    public func send(completion: Subscribers.Completion<Failure>) {
        let set = subscribers.mutate { (subs: inout Dictionary<CombineIdentifier, ESubscription<Behavior>>) -> Dictionary<CombineIdentifier, ESubscription<Behavior>> in
            let previous = subs
            subs.removeAll()
            return previous
        }
        
        for (_, sub) in set {
            sub.receive(completion: completion)
        }
    }
    
    public func receive<S>(subscriber: S) where S: Subscriber, Failure == S.Failure, Output == S.Input {
        let behavior = Behavior(subject: self, downstream: AnySubscriber(subscriber))
        let subscription = ESubscription(behavior: behavior)
        subscribers.mutate { $0[subscription.combineIdentifier] = subscription }
        subscription.receive(subscription: Subscriptions.empty)
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




public final class AtomicBox<T> {
    @usableFromInline
    var mutex = os_unfair_lock()
    
    @usableFromInline
    var internalValue: T
    
    public init(_ t: T) {
        internalValue = t
    }
    
    @inlinable
    public var value: T {
        get {
            os_unfair_lock_lock(&mutex)
            defer { os_unfair_lock_unlock(&mutex) }
            return internalValue
        }
    }
    
    public var isMutating: Bool {
        if os_unfair_lock_trylock(&mutex) {
            os_unfair_lock_unlock(&mutex)
            return false
        }
        return true
    }
    
    @discardableResult @inlinable
    public func mutate<U>(_ f: (inout T) throws -> U) rethrows -> U {
        os_unfair_lock_lock(&mutex)
        defer { os_unfair_lock_unlock(&mutex) }
        return try f(&internalValue)
    }
}
