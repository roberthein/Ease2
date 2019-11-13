import Foundation
import SceneKit.SceneKitTypes

extension SCNVector3: Easable {
    
    public typealias Scalar = Float
    
    public var scalars: [Float] {
        get { [x, y, z] }
        set { x = newValue[0]; y = newValue[1]; z = newValue[2] }
    }
    
    public static var zero: SCNVector3 { .init(0, 0, 0) }
}
