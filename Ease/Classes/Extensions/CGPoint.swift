import Foundation
import CoreGraphics

extension CGPoint: Easable {
    
    public typealias F = CGFloat
    
    public var values: [CGFloat] {
        get { [x, y] }
        set { self = CGPoint(with: newValue) }
    }
    
    public init(with values: [CGFloat]) {
        self.init(x: values[0], y: values[1])
    }
}
