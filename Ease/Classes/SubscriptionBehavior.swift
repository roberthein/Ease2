import Foundation
import Combine

@available(iOS 13.0, *)
public protocol SubscriptionBehavior: class, Cancellable, CustomCombineIdentifierConvertible {
    associatedtype Input
    associatedtype Failure: Error
    associatedtype Output
    associatedtype OutputFailure: Error
    
    var demand: Subscribers.Demand { get set }
    var upstream: Subscription? { get set }
    var downstream: AnySubscriber<Output, OutputFailure> { get }
    
    func request(_ d: Subscribers.Demand)
    func receive(_ input: Input) -> Subscribers.Demand
    func receive(completion: Subscribers.Completion<Failure>)
}

@available(iOS 13.0, *)
public extension SubscriptionBehavior {
    
    func request(_ d: Subscribers.Demand) {
        demand += d
        upstream?.request(d)
    }
    
    func cancel() {
        upstream?.cancel()
    }
}

@available(iOS 13.0, *)
public extension SubscriptionBehavior where Input == Output, Failure == OutputFailure {
    
    func receive(_ input: Input) -> Subscribers.Demand {
        
        if demand > 0 {
            let newDemand = downstream.receive(input)
            demand = newDemand + (demand - 1)
            return newDemand
        }
        
        return Subscribers.Demand.none
    }
}

@available(iOS 13.0, *)
public extension SubscriptionBehavior where Failure == OutputFailure {
    
    func receive(completion: Subscribers.Completion<Failure>) {
        downstream.receive(completion: completion)
    }
}
