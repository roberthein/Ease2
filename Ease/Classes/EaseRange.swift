import Foundation
import QuartzCore
import Combine

public struct EaseRange<E: Easable> {
    let min: E
    let max: E
    
    var closedRanges: [ClosedRange<E.F>] {
        return min.values.enumeratedMap { $1 ... max.values[$0] }
    }
    
    public init(min: E, max: E) {
        self.min = min
        self.max = max
    }
}
