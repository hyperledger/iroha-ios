import Foundation
import IrohaSwiftScale

public struct Tuple4<T1: Codable, T2: Codable, T3: Codable, T4: Codable>: Codable {
    
    /// Ignore tuple var
    private enum CodingKeys: String, CodingKey {
        case _0, _1, _2, _3
    }
    
    public var tuple: (T1, T2, T3, T4) {
        get { (_0, _1, _2, _3) }
        set {
            _0 = newValue.0
            _1 = newValue.1
            _2 = newValue.2
            _3 = newValue.3
        }
    }
    
    public var _0: T1
    public var _1: T2
    public var _2: T3
    public var _3: T4
    
    public init(_ _0: T1, _ _1: T2, _ _2: T3, _ _3: T4) {
        self._0 = _0
        self._1 = _1
        self._2 = _2
        self._3 = _3
    }
}

typealias TestTupleStruct = Tuple4<UInt8, String, UInt128, Bool>
