import Foundation
import Combine

public struct EaseRange<E: Easable> {

  let min: E
  let max: E

  var closedRanges: [ClosedRange<E.Scalar>] {
    min.scalars.enumerated().map { $1 ... max.scalars[$0] }
  }

  public init(min: E, max: E) {
    self.min = min
    self.max = max
  }
}
