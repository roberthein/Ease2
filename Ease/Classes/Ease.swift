import Foundation
import QuartzCore
import Combine

@available(iOS 13.0, *)
public final class Ease<E: Easable> {
    
    public typealias EasePublisher = Published<E>.Publisher
    
    @Published public private(set) var value: E
    @Published public var targetValue: E
    
    var wraps: [Int: SpringWrap<E>] = [:]
    
    private var keys = (0...).makeIterator()
    
    var disposal = Set<AnyCancellable>()
    
    public required init(_ value: E) {
        self.value = value
        self.targetValue = value
    }
    
    public func add(tension: E.F, damping: E.F, mass: E.F) -> EasePublisher {
        let key = keys.next()!
        wraps[key] = SpringWrap(value, tension, damping, mass)
        
        return wraps[key]!.$value
    }
    
    public func update(_ time: TimeInterval) {
        
        wraps.values.forEach { wrap in
            wrap.interpolate(to: targetValue, duration: E.float(from: time))
        }
    }
}
