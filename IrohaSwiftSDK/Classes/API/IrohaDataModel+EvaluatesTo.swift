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
        case .id:
            return .init(expression: .raw(self))
        case .numeric(let numeric):
            return .init(expression: .raw(self))
        case .bool(let bool):
            fatalError()
        case .string(let string):
            return .init(expression: .raw(self))
        case .name(let string):
            return .init(expression: .raw(self))
        case .vec(let array):
            fatalError()
        case .identifiable(let identifiableBox):
            fatalError()
        case .publicKey(let publicKey):
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
