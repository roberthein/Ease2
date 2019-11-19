import Foundation
import SceneKit.SceneKitTypes

extension CGSize: Easable {
    
    public typealias Scalar = CGFloat
    
    public var scalars: [CGFloat] {
        get { [width, height] }
        set { width = newValue[0]; height = newValue[1] }
    }
    
    public static func scalar(_ scalar: Float) -> CGFloat {
        return CGFloat(scalar)
    }
}
