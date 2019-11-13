import Foundation
import Combine

@available(iOS 13.0, *)
public final class EasePublisher<E: Easable> {
    
    let subject: CurrentValueSubject<E, Never>
    var spring: EaseSpring<E>
    
    init(_ initialValue: E, spring: EaseSpring<E>) {
        self.subject = CurrentValueSubject<E, Never>(initialValue)
        self.spring = spring
    }
    
    public func update(_ targetValue: E, _ time: E.Scalar) {
        subject.send(subject.value.lerp(targetValue: targetValue, spring: &spring, duration: time))
    }
}
