import Foundation
import QuartzCore
import Combine

@available(iOS 13.0, *)
public final class Ease<E: Easable> {
    
    @Published private(set) public var value: E
    @Published public var targetValue: E
    
    var disposal = Set<AnyCancellable>()
    var publishers: [Int: EasePublisher<E>] = [:]
    
    private var keys = (0...).makeIterator()
    
    public required init(_ value: E) {
        self.value = value
        self.targetValue = value
    }
    
    public func add(_ springs: [EaseSpring<E.F>]) -> AnyPublisher<[E], Never> {
        let sequence = Publishers.Sequence<[Published<E>.Publisher], Never>(sequence: springs.map({ spring in add(spring) }))
        return sequence.flatMap { $0 }.collect().eraseToAnyPublisher()
    }
    
    public func add(_ spring: EaseSpring<E.F>) -> Published<E>.Publisher {
        add(tension: spring.tension, damping: spring.damping, mass: spring.mass)
    }
    
    public func add(tension: E.F, damping: E.F, mass: E.F) -> Published<E>.Publisher {
        let key = keys.next()!
        publishers[key] = EasePublisher(value, tension, damping, mass)
        
        return publishers[key]!.$value
    }
    
    public func update(_ time: E.F) {
        publishers.forEach { $1.update(targetValue, time) }
    }
}
