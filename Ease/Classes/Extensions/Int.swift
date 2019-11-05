import Foundation

extension Int: Easable {
    
    public typealias F = Float
    
    public static var zero: Int { 0 }
    
    public var values: [Float] {
        get { [Float(self)] }
        set { self = Int(with: newValue) }
    }
    
    public init(with values: [Float]) {
        self.init(Int(values[0]))
    }
}
