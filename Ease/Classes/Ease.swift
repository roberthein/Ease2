import Foundation
import Combine

@available(iOS 13.0, *)
public final class Ease<E: Easable> {
    
    public var target: E
    var publishers: [Int: EasePublisher<E>] = [:]
    private var keys = (0...).makeIterator()
    
    public required init(_ value: E) {
        target = value
    }
    
    public func spring(t tension: E.Scalar, d damping: E.Scalar, m mass: E.Scalar, rubberBandRange: EaseRange<E>? = nil, rubberBandResilience: E.Scalar? = nil, clampRange: EaseRange<E>? = nil) -> AnyPublisher<E, Never> {
        let key = keys.next()!
        publishers[key] = EasePublisher(target, spring: EaseSpring(tension, damping, mass))
        
        return publishers[key]!.subject
            .rubberBand(rubberBandRange, rubberBandResilience)
            .clamp(clampRange)
            .eraseToAnyPublisher()
    }
    
    public func update(_ time: E.Scalar) {
        publishers.values.forEach { $0.update(target, time) }
    }
}
