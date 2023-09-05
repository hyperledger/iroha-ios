//
//  TransactionBuilder.swift
//  IrohaSwiftSDK
//
//  Created by Nikolai Zhukov on 8/21/23.
//

import Foundation

public class TransationBuilder {
    private enum Constants {
        static var timeToLive: TimeInterval = 100
        static var metadataNameKey = "name"
        static var metadataStringKey = "string"
        static var metadataDescription = "description"
    }

    public enum TransationError: Error {
        case noAccountId
        case noCreationDate
    }

    public init() {
    }

    private var instructions: [IrohaDataModelIsi.Instruction] = []

    private var accountId: IrohaDataModelAccount.Id?

    private var createdDate: Date?

    private var description: String?

    public func withCreatedDate(date: Date) -> Self {
        self.createdDate = date

        return self
    }

    public func account(accountId: IrohaDataModelAccount.Id) -> Self {
        self.accountId = accountId

        return self
    }

    public func withDescription(description: String?) -> Self {
        self.description = description

        return self
    }

    public func transferAsset(assetID: IrohaDataModelAsset.Id, value: UInt32, receiverID: IrohaDataModelAccount.Id) -> Self {
        let sourceID = IrohaDataModel.IdBox.assetId(assetID)
        let source: IrohaDataModel.Value = .id(sourceID)

        let uValue: IrohaDataModel.Value = .u32(value)

        let destinationID = IrohaDataModel.IdBox.accountId(receiverID)
        let destination: IrohaDataModel.Value = .id(destinationID)

        let box = IrohaDataModelIsi.TransferBox(
            sourceId: source.evaluatesTo,
            object: uValue.evaluatesTo,
            destinationId: destination.evaluatesTo)

        instructions.append(.transfer(box))

        return self
    }

    public func buildSigned(keyPair: IrohaKeyPair) throws -> IrohaDataModelTransaction.VersionedTransaction {
        guard let accountId else {
            throw TransationError.noAccountId
        }

        guard let createdDate else {
            throw TransationError.noCreationDate
        }

        var metadata: [String: IrohaDataModel.Value] = [:]
        if let description {
            metadata[Constants.metadataNameKey] = .string(Constants.metadataDescription)
            metadata[Constants.metadataStringKey] = .string(description)
        }

        //debugPrint(Int64.min)
        //debugPrint(Int64.max)

        let payload = IrohaDataModelTransaction.Payload(
            accountId: accountId,
            instructions: instructions,
            creationTime: createdDate.milliseconds,
            timeToLiveMs: Constants.timeToLive.milliseconds,
            nonce: Int64.random(in: Int64.min...Int64.max),
            metadata: metadata
        )

        let signature = try IrohaCrypto.Signature(signing: payload, with: keyPair)
        let transaction = IrohaDataModelTransaction.Transaction(payload: payload, signatures: [signature])

        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = [.withoutEscapingSlashes, .prettyPrinted]
        let jsonData = try jsonEncoder.encode(transaction)
        let json = String(data: jsonData, encoding: .utf8)

        print(json!.replacingOccurrences(of: "\\/", with: "/") )

        return .v1(transaction)
    }
}
