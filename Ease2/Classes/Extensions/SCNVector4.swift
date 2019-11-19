import Foundation
import SceneKit.SceneKitTypes

extension SCNVector4: Easable {
    
    public typealias Scalar = Float
    
    public var scalars: [Float] {
        get { [x, y, z, w] }
        set { x = newValue[0]; y = newValue[1]; z = newValue[2]; w = newValue[3] }
    }
    
    public static var zero: SCNVector4 { .init(0, 0, 0, 0) }
    
    public static func scalar(_ scalar: Float) -> Float {
        return Float(scalar)
    }
}
