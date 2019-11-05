import Foundation
import CoreGraphics

extension CGVector: Easable {
    
    public typealias F = CGFloat
    
    public var values: [CGFloat] {
        get { [dx, dy] }
        set { self = CGVector(with: newValue) }
    }
    
    public init(with values: [CGFloat]) {
        self.init(dx: values[0], dy: values[1])
    }
}
