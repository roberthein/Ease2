import Foundation
import CoreGraphics

extension CGSize: Easable {
    
    public typealias F = CGFloat
    
    public var values: [CGFloat] {
        get { [width, height] }
        set { self = CGSize(with: newValue) }
    }
    
    public init(with values: [CGFloat]) {
        self.init(width: values[0], height: values[1])
    }
}
