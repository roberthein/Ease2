import Foundation

public extension Notification.Name {
  static let easeState = Notification.Name("EaseState")
}

public enum EaseState {
  case paused
  case playing
}
