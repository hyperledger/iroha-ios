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
        static var durationOf24HoursInMilliseconds: UInt64 = 86_400_000
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

    private var crosschainAddress: CrosschainAddress?

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

    public func withCrosschainAddress(crosschainAddress: CrosschainAddress?) -> Self {
        self.crosschainAddress = crosschainAddress

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

    public func grantPermissionToken(permission: Permission, params: IrohaMetadataItem..., destinationId: IrohaDataModelAccount.Id) -> Self {
        let token = IrohaDataModelPermissions.PermissionToken(name: permission.rawValue, params: params)
        let permissionToken: IrohaDataModel.Value = .permissionToken(token)
        let destinationId = IrohaDataModel.IdBox.accountId(destinationId)
        let destination: IrohaDataModel.Value = .id(destinationId)

        let box = IrohaDataModelIsi.GrantBox(object: permissionToken.evaluatesTo, destinationId: destination.evaluatesTo)

        instructions.append(.grant(box))

        return self
    }

    public func buildSigned(keyPair: IrohaKeyPair) throws -> IrohaDataModelTransaction.VersionedTransaction {
        guard let accountId else {
            throw TransationError.noAccountId
        }

        var metadata: [IrohaMetadataItem] = []
        if let description {
            let item = IrohaMetadataItem(name: .description, value: .string(description))
            metadata.append(item)
        }

        if let crosschainAddress = crosschainAddress {
            let networkItem = IrohaMetadataItem(name: .network, value: .string(crosschainAddress.network))
            metadata.append(networkItem)

            let addressItem = IrohaMetadataItem(name: .address, value: .string(crosschainAddress.address))
            metadata.append(addressItem)
        }

        let payload = IrohaDataModelTransaction.Payload(
            accountId: accountId,
            executable: .instructions(instructions),
            creationTime: (createdDate ?? Date()).milliseconds,
            timeToLiveMs: timeToLiveMs ?? Constants.durationOf24HoursInMilliseconds,
            nonce: nonce ?? UInt32.random(in: 0...UInt32.max),
            metadata: metadata
        )

        let signature = try IrohaCrypto.Signature(signing: payload, with: keyPair)
        let transaction = IrohaDataModelTransaction.Transaction(payload: payload, signatures: [signature])

        return .v1(transaction)
    }
}
