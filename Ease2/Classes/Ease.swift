import Foundation
import Combine

@available(iOS 13.0, *)
public final class Ease<E: Easable> {
    
    public var target: E {
        didSet {
            state = .playing
        }
    }
    
    var publishers: [Int: EasePublisher<E>] = [:]
    private var ids = (0...).makeIterator()
    
    public var projection: EaseProjection<E>?
    
    public var velocity: E {
        get { publishers.values.map { $0.spring.velocity }.first ?? .zero }
        set { publishers.values.forEach { $0.spring.velocity = newValue } }
    }
    
    public var state: EaseState {
        get { publishers.values.map { $0.state }.contains(.playing) ? .playing : .paused }
        set { publishers.values.forEach { $0.state = newValue } }
    }
    
    public required init(_ value: E, targets: [E]? = nil) {
        self.target = value
        
        if let targets = targets {
            projection = EaseProjection(targets: targets)
        }
    }
    
    /// Add spring parameters for the spring animation
    /// - Parameters:
    ///   - tension: The tension of the spring.
    ///   - damping: The dampig the spring is subjected to.
    ///   - mass: The mass of the subject.
    public func spring(t tension: E.Scalar, d damping: E.Scalar, m mass: E.Scalar, rubberBandRange: EaseRange<E>? = nil, rubberBandResilience: E.Scalar? = nil, clampRange: EaseRange<E>? = nil) -> AnyPublisher<E, Never> {
        let id = ids.next()!
        publishers[id] = EasePublisher(target, spring: EaseSpring(tension, damping, mass, target))
        
        return publishers[id]!.subject
            .rubberBand(rubberBandRange, rubberBandResilience)
            .clamp(clampRange)
            .eraseToAnyPublisher()
    }
    
    public func update(_ time: E.Scalar, _ minimumStep: E.Scalar) {
        publishers.values.forEach { $0.update(target, time, minimumStep) }
    }
}
