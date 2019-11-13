import Foundation
import Combine

@available(iOS 13.0, *)
internal extension Publisher where Self.Output: Easable {
    
    func clamp(_ clampRange: EaseRange<Self.Output>?) -> Publishers.Map<Self, Self.Output> {
        guard let clampRange = clampRange else { return map { $0 } }
        return map { $0.clamp(range: clampRange) }
    }
    
    func rubberBand(_ rubberBandRange: EaseRange<Self.Output>?, _ resilience: Self.Output.Scalar?) -> Publishers.Map<Self, Self.Output> {
        guard let rubberBandRange = rubberBandRange, let resilience = resilience else { return map { $0 } }
        return map { $0.rubberBand(in: rubberBandRange, with: resilience) }
    }
}
