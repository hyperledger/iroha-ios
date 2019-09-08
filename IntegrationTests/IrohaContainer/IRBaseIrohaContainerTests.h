/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

@import XCTest;
@import IrohaCommunication;
@import IrohaCrypto;

NS_ASSUME_NONNULL_BEGIN

@interface IRBaseIrohaContainerTests : XCTestCase

@property (strong, nonatomic) IRNetworkService *iroha;
@property (strong, nonatomic) id<IRAccountId> adminAccountId;
@property (strong, nonatomic) id<IRPublicKeyProtocol> adminPublicKey;
@property (strong, nonatomic) id<IRSignatureCreatorProtocol> adminSigner;
@property (strong, nonatomic) id<IRDomain> domain;

@end

NS_ASSUME_NONNULL_END
