import Foundation
import CoreGraphics

extension CGFloat: Easable {
    
    public typealias F = CGFloat
    
    public static var zero: CGFloat { 0 }
    
    public var values: [CGFloat] {
        get { [self] }
        set { self = CGFloat(with: newValue) }
    }
    
    public init(with values: [CGFloat]) {
        self.init(values[0])
    }
}
