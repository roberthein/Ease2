import Foundation
import SceneKit.SceneKitTypes

extension CGFloat: Easable {
    
    public typealias Scalar = CGFloat
    
    public var scalars: [CGFloat] {
        get { [self] }
        set { self = newValue[0] }
    }
    
    public static var zero: CGFloat { 0 }
}
