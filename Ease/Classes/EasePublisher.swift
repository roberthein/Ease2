import Foundation
import Combine

@available(iOS 13.0, *)
public final class EasePublisher<E: Easable> {
    
    let subject: CurrentValueSubject<E, Never>
    var spring: EaseSpring<E>
    
    var state: EaseState = .paused
    
    init(_ initialValue: E, spring: EaseSpring<E>) {
        self.subject = CurrentValueSubject<E, Never>(initialValue)
        self.spring = spring
    }
    
    public func update(_ target: E, _ time: E.Scalar, _ minimumStep: E.Scalar) {
        let value = subject.value.lerp(target: target, spring: &spring, duration: time)
        
        if spring.shouldPause(value, target, minimumStep) {
            state = .paused
        } else {
            state = .playing
            subject.send(value)
        }
    }
}
