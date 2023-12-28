import Foundation

public struct EaseProjection<E: Easable> {

  public let targets: [E]

  public init(targets: [E]) {
    self.targets = targets
  }

  public func target(for start: E, with velocity: E, decelerationRate: E.Scalar) -> E {
    let projection: E = .new(start.scalars.enumerated().map { $1 + project(velocity: velocity.scalars[$0], decelerationRate: decelerationRate) })

    return nearest(to: projection) ?? projection
  }

  private func project(velocity: E.Scalar, decelerationRate: E.Scalar) -> E.Scalar { velocity * decelerationRate / (1 - decelerationRate) }

  private func nearest(to projection: E) -> E? {
    targets.min(
      by: {
        $0.distance(to: projection) < $1.distance(to: projection)
      }
    )
  }
}
