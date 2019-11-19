import Foundation
import SceneKit.SceneKitTypes

extension Int: Easable {
    
    public typealias Scalar = Float
    
    public var scalars: [Float] {
        get { [Float(self)] }
        set { self = Int(newValue[0]) }
    }
    
    public static var zero: Int { 0 }
}
