//
//  IrohaDataModel+EvaluatesTo.swift
//  IrohaSwiftSDK
//
//  Created by Nikolai Zhukov on 8/21/23.
//

import Foundation

public extension IrohaDataModel.Value {
    var evaluatesTo: IrohaDataModelExpression.EvaluatesTo {
        switch self {
        case .u32, .id:
            return .init(expression: .raw(self))
        case .bool(let bool):
            fatalError()
        case .string(let string):
            fatalError()
        case .fixed(let fixed):
            fatalError()
        case .vec(let array):
            fatalError()
        case .identifiable(let identifiableBox):
            fatalError()
        case .publicKey(let publicKey):
            fatalError()
        case .parameter(let parameter):
            fatalError()
        case .signatureCheckCondition(let signatureCheckCondition):
            fatalError()
        case .transactionValue(let transactionValue):
            fatalError()
        case .permissionToken(let permissionToken):
            fatalError()
        }
    }
}
