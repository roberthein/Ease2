import Foundation
import Combine

@available(iOS 13.0, *)
public final class Ease<E: Easable> {
    
    public var targetValue: E
    var publishers: [Int: EasePublisher<E>] = [:]
    private var keys = (0...).makeIterator()
    
    public required init(_ value: E) {
        self.targetValue = value
    }
    
    public func add(_ spring: EaseSpring<E>, rubberBandRange: EaseRange<E>? = nil, rubberBandResilience: E.Scalar? = nil, clampRange: EaseRange<E>? = nil) -> AnyPublisher<E, Never> {
        let key = keys.next()!
        publishers[key] = EasePublisher(targetValue, spring: spring)
        
        return publishers[key]!.subject
            .rubberBand(rubberBandRange, rubberBandResilience)
            .clamp(clampRange)
            .eraseToAnyPublisher()
    }
    
    public func update(_ time: E.Scalar) {
        publishers.values.forEach { $0.update(targetValue, time) }
    }
}
