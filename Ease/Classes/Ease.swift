import Foundation
import QuartzCore
import Combine

@available(iOS 13.0, *)
public final class Ease<E: Easable> {
    
    @Published public private(set) var value: E
    @Published public var targetValue: E
    
    var publishers: [Int: EasePublisher<E>] = [:]
    
    private var keys = (0...).makeIterator()
    
    var disposal = Set<AnyCancellable>()
    
    public required init(_ value: E) {
        self.value = value
        self.targetValue = value
    }
    
    public func add(tension: E.F, damping: E.F, mass: E.F) -> Published<E>.Publisher {
        let key = keys.next()!
        publishers[key] = EasePublisher(value, tension, damping, mass)
        
        return publishers[key]!.$value
    }
    
    public func update(_ time: TimeInterval) {
        
        publishers.values.forEach { publisher in
            publisher.interpolate(to: targetValue, duration: E.float(from: time))
        }
    }
}
