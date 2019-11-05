import Foundation
import QuartzCore
import SceneKit.SceneKitTypes

extension SCNVector3: Easable {
    
    public typealias F = Float
    
    public static var zero: SCNVector3 { SCNVector3Zero }
    
    public var values: [Float] {
        get { [x, y, z] }
        set { self = SCNVector3(with: newValue) }
    }
    
    public init(with values: [Float]) {
        self.init(values[0], values[1], values[2])
    }
}
