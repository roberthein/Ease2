import Foundation
import SceneKit.SceneKitTypes

extension CGPoint: Easable {
    
    public typealias Scalar = CGFloat
    
    public var scalars: [CGFloat] {
        get { [x, y] }
        set { x = newValue[0]; y = newValue[1] }
    }
    
    public static func scalar(_ scalar: Float) -> CGFloat {
        return CGFloat(scalar)
    }
}
