/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

@import XCTest;
@import SwiftyIroha;
@import IrohaCrypto;

@interface IRBaseIrohaContainerTests : XCTestCase

@property(strong, nonatomic)IRNetworkService * _Nonnull iroha;

@property(strong, nonatomic)id<IRAccountId> _Nonnull adminAccountId;
@property(strong, nonatomic)id<IRPublicKeyProtocol> _Nonnull adminPublicKey;
@property(strong, nonatomic)id<IRSignatureCreatorProtocol> _Nonnull adminSigner;
@property(strong, nonatomic)id<IRDomain> _Nonnull domain;

@end
