import Foundation
import SceneKit.SceneKitTypes

extension Double: Easable {
    
    public typealias Scalar = Double
    
    public var scalars: [Double] {
        get { [self] }
        set { self = newValue[0] }
    }
    
    public static var zero: Double { 0 }
}
