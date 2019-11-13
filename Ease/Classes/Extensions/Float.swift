import Foundation
import SceneKit.SceneKitTypes

extension Float: Easable {
    
    public typealias Scalar = Float
    
    public var scalars: [Float] {
        get { [self] }
        set { self = newValue[0] }
    }
    
    public static var zero: Float { 0 }
}
