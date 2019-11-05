import Foundation
import CoreGraphics

extension Double: Easable {
    
    public typealias F = Double
    
    public static var zero: Double { 0 }
    
    public var values: [Double] {
        get { [self] }
        set { self = Double(with: newValue) }
    }
    
    public init(with values: [Double]) {
        self.init(values[0])
    }
}
