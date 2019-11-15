import Foundation
import Combine

@available(iOS 13.0, *)
internal extension Publisher where Output: Easable {
    
    func clamp(_ clampRange: EaseRange<Output>?) -> Publishers.Map<Self, Output> {
        guard let clampRange = clampRange else { return map { $0 } }
        return map { $0.clamp(range: clampRange) }
    }
    
    func rubberBand(_ rubberBandRange: EaseRange<Output>?, _ resilience: Output.Scalar?) -> Publishers.Map<Self, Output> {
        guard let rubberBandRange = rubberBandRange, let resilience = resilience else { return map { $0 } }
        return map { $0.rubberBand(in: rubberBandRange, with: resilience) }
    }
}
