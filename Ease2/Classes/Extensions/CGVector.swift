import Foundation
import SceneKit.SceneKitTypes

extension CGVector: Easable {
    
    public typealias Scalar = CGFloat
    
    public var scalars: [CGFloat] {
        get { [dx, dy] }
        set { dx = newValue[0]; dy = newValue[1] }
    }
    
    public static func scalar(_ scalar: Float) -> CGFloat {
        return CGFloat(scalar)
    }
}
