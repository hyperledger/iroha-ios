//
//  TransactionBuilder.swift
//  IrohaSwiftSDK
//
//  Created by Nikolai Zhukov on 8/21/23.
//

import Foundation
import IrohaSwiftScale

public class TransationBuilder {
    private enum Constants {
        static var timeToLive: TimeInterval = 100
        static var metadataDescription = "description"
    }

    public enum TransationError: Error {
        case noAccountId
        case noCreationDate
        case notNumber
    }

    public init() {
    }

    private var instructions: [IrohaDataModelIsi.Instruction] = []

    private var accountId: IrohaDataModelAccount.Id?

    private var createdDate: Date?

    private var description: String?

    private var timeToLiveMs: UInt64?

    private var nonce: UInt32?

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

    public func withTimeToLiveMs(timeToLiveMs: UInt64?) -> Self {
        self.timeToLiveMs = timeToLiveMs

        return self
    }

    public func withNonce(nonce: UInt32?) -> Self {
        self.nonce = nonce

        return self
    }

    public func transferAsset(assetID: IrohaDataModelAsset.Id, value: IrohaDataModelTransaction.NumericValue, receiverID: IrohaDataModelAccount.Id) -> Self {
        let sourceID = IrohaDataModel.IdBox.assetId(assetID)
        let source: IrohaDataModel.Value = .id(sourceID)
        let destinationID = IrohaDataModel.IdBox.accountId(receiverID)
        let destination: IrohaDataModel.Value = .id(destinationID)
        let number: IrohaDataModel.Value = .numeric(value)

        let box = IrohaDataModelIsi.TransferBox(
            sourceId: source.evaluatesTo,
            object: number.evaluatesTo,
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

        var metadata: [IrohaDataModelName] = []
        if let description {
            let item = IrohaDataModelName(name: Constants.metadataDescription, value: .string(description))
            metadata.append(item)
        }

        let payload = IrohaDataModelTransaction.Payload(
            accountId: accountId,
            executable: .instructions(instructions),
            creationTime: createdDate.milliseconds,
            timeToLiveMs: timeToLiveMs ?? Constants.timeToLive.milliseconds,
            nonce: nonce ?? UInt32.random(in: 0...UInt32.max),
            metadata: metadata
        )

        let signature = try IrohaCrypto.Signature(signing: payload, with: keyPair)
        let transaction = IrohaDataModelTransaction.Transaction(payload: payload, signatures: [signature])

        return .v1(transaction)
    }
}
