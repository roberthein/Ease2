import Foundation

extension Float: Easable {
    
    public typealias F = Float
    
    public static var zero: Float { 0 }
    
    public var values: [Float] {
        get { [self] }
        set { self = Float(with: newValue) }
    }
    
    public init(with values: [Float]) {
        self.init(values[0])
    }
}
