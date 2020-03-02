/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#import <XCTest/XCTest.h>
#import "IRBaseIrohaContainerTests.h"

@interface IRAccountRestoreWithBatchTest : IRBaseIrohaContainerTests

@property (strong, nonatomic) id<IRRoleName> userRole;
@property (strong, nonatomic) id<IRDomain> bankDomain;
@property (strong, nonatomic) id<IRDomain> recoveryDomain;
@property (strong, nonatomic) id<IRAccountId> recoveryAccount;
@property (strong, nonatomic) id<IRCryptoKeypairProtocol> recoveryKeypair;
@property (strong, nonatomic) id<IRSignatureCreatorProtocol> recoverySigner;
@property (strong, nonatomic) id<IRAccountId> clientAccount;
@property (strong, nonatomic) id<IRCryptoKeypairProtocol> clientKeypair;
@property (strong, nonatomic) id<IRSignatureCreatorProtocol> clientSigner;

@end

@implementation IRAccountRestoreWithBatchTest

- (void)setUp {
    [super setUp];

    _userRole = [IRRoleNameFactory roleWithName:@"user" error:nil];
    _recoveryDomain = [IRDomainFactory domainWithIdentitifer:@"cmb.recovery" error:nil];
    _bankDomain = [IRDomainFactory domainWithIdentitifer:@"cmb" error:nil];
    _recoveryAccount = [IRAccountIdFactory accountIdWithName:@"recovery" domain:_recoveryDomain error:nil];
    _recoveryKeypair = [[IRIrohaKeyFactory new] createRandomKeypair:nil];
    _recoverySigner = [[IRIrohaSigner alloc] initWithPrivateKey:_recoveryKeypair.privateKey];
    _clientAccount = [IRAccountIdFactory accountIdWithName:@"client" domain:_bankDomain error:nil];
    _clientKeypair = [[IRIrohaKeyFactory new] createRandomKeypair: nil];
    _clientSigner = [[IRIrohaSigner alloc] initWithPrivateKey:_clientKeypair.privateKey];
}

- (void)testAccountRestoreScenarioWithoutBatch {
    XCTestExpectation *expectation = [[XCTestExpectation alloc] init];

    [self createDomains].onThen(^IRPromise* _Nullable (id result) {
        return [IRRepeatableStatusStream onTransactionStatus:IRTransactionStatusCommitted
                                                    withHash:result
                                                        from:self.iroha];
    }).onThen(^IRPromise * _Nullable (id result) {
        return [self createAccounts];
    }).onThen(^IRPromise * _Nullable (id result) {
        return [IRRepeatableStatusStream onTransactionStatus:IRTransactionStatusCommitted
                                                    withHash:result
                                                        from:self.iroha];
    }).onThen(^IRPromise * _Nullable (id result) {
        return [self grandClientToRecoveryPermissions];
    }).onThen(^IRPromise * _Nullable (id result) {
        return [IRRepeatableStatusStream onTransactionStatus:IRTransactionStatusCommitted
                                                    withHash:result
                                                        from:self.iroha];
    }).onThen(^IRPromise * _Nullable (id result) {
        return [self grandRecoveryToAdminPermissions];
    }).onThen(^IRPromise * _Nullable (id result) {
        return [IRRepeatableStatusStream onTransactionStatus:IRTransactionStatusCommitted
                                                    withHash:result
                                                        from:self.iroha];
    }).onThen(^IRPromise * _Nullable (id result) {
        return [self setupRecoveryAccount];
    }).onThen(^IRPromise * _Nullable (id result) {
        return [IRRepeatableStatusStream onTransactionStatus:IRTransactionStatusCommitted
                                                    withHash:result
                                                        from:self.iroha];
    }).onThen(^IRPromise * _Nullable (id result) {
        [expectation fulfill];

        return nil;
    }).onError(^IRPromise* _Nullable (NSError * error) {
        XCTFail(@"%@", error);

        [expectation fulfill];

        return nil;
    });

    [self waitForExpectations:@[expectation] timeout:600.0];
}

- (void)testAccountRestoreScenarioWithBatch {
    XCTestExpectation *expectation = [[XCTestExpectation alloc] init];

    [self createDomains].onThen(^IRPromise * _Nullable (id result) {
        return [IRRepeatableStatusStream onTransactionStatus:IRTransactionStatusCommitted
                                                    withHash:result
                                                        from:self.iroha];
    }).onThen(^IRPromise * _Nullable (id result) {
        return [self createAccounts];
    }).onThen(^IRPromise* _Nullable (id result) {
        return [IRRepeatableStatusStream onTransactionStatus:IRTransactionStatusCommitted
                                                    withHash:result
                                                        from:self.iroha];
    }).onThen(^IRPromise * _Nullable (id result) {
        return [self sendRecoverySetupBatch];
    }).onThen(^IRPromise * _Nullable (id result) {
        return [IRRepeatableStatusStream onTransactionStatus:IRTransactionStatusCommitted
                                                    withHash:[result objectAtIndex:0]
                                                        from:self.iroha];
    }).onThen(^IRPromise * _Nullable (id result) {
        [expectation fulfill];

        return nil;
    }).onError(^IRPromise * _Nullable (NSError *error) {
        XCTFail(@"%@", error);

        [expectation fulfill];

        return nil;
    });

    [self waitForExpectations:@[expectation] timeout:600.0];
}

#pragma mark - Private

- (nonnull IRPromise*)createDomains {
    IRTransactionBuilder* builder = [IRTransactionBuilder builderWithCreatorAccountId:self.adminAccountId];
    builder = [builder createDomain:_recoveryDomain defaultRole:_userRole];
    builder = [builder createDomain:_bankDomain defaultRole:_userRole];

    id<IRTransaction> transaction = [[builder build:nil] signedWithSignatories:@[self.adminSigner]
                                                           signatoryPublicKeys:@[self.adminPublicKey]
                                                                         error:nil];

    return [self.iroha executeTransaction:transaction];
}

- (nonnull IRPromise*)createAccounts {
    IRTransactionBuilder *builder = [IRTransactionBuilder builderWithCreatorAccountId:self.adminAccountId];
    builder = [builder createAccount:_recoveryAccount publicKey:_recoveryKeypair.publicKey];
    builder = [builder createAccount:_clientAccount publicKey:_clientKeypair.publicKey];

    id<IRTransaction> transaction = [[builder build:nil] signedWithSignatories:@[self.adminSigner]
                                                           signatoryPublicKeys:@[self.adminPublicKey]
                                                                         error:nil];

    return [self.iroha executeTransaction:transaction];
}

- (nonnull IRPromise*)sendRecoverySetupBatch {
    id<IRTransaction> clientToRecoveryPermissionsTransaction = [self createGrandClientToRecoveryPermissionsTransaction];
    id<IRTransaction> recoveryToAdminPermissionsTransaction = [self createGrandRecoveryToAdminPermissionsTransaction];
    id<IRTransaction> setupRecoveryAccountTransaction = [self createSetupRecoveryAccountTransaction];

    NSData *clientPermissionsHash = [clientToRecoveryPermissionsTransaction batchHashWithError:nil];
    NSData *recoveryPermissionsHash = [recoveryToAdminPermissionsTransaction batchHashWithError:nil];
    NSData *recoverySetupHash = [setupRecoveryAccountTransaction batchHashWithError:nil];

    clientToRecoveryPermissionsTransaction = [clientToRecoveryPermissionsTransaction batched:@[clientPermissionsHash, recoveryPermissionsHash, recoverySetupHash]
                                                                                   batchType:IRTransactionBatchTypeAtomic
                                                                                       error:nil];

    clientToRecoveryPermissionsTransaction = [clientToRecoveryPermissionsTransaction signedWithSignatories:@[_clientSigner]
                                                                                       signatoryPublicKeys:@[_clientKeypair.publicKey]
                                                                                                     error:nil];

    recoveryToAdminPermissionsTransaction = [recoveryToAdminPermissionsTransaction batched:@[clientPermissionsHash, recoveryPermissionsHash, recoverySetupHash]
                                                                                 batchType:IRTransactionBatchTypeAtomic
                                                                                     error:nil];

    recoveryToAdminPermissionsTransaction = [recoveryToAdminPermissionsTransaction signedWithSignatories:@[_recoverySigner]
                                                                                     signatoryPublicKeys:@[_recoveryKeypair.publicKey]
                                                                                                   error:nil];

    setupRecoveryAccountTransaction = [setupRecoveryAccountTransaction batched:@[clientPermissionsHash, recoveryPermissionsHash, recoverySetupHash]
                                                                     batchType:IRTransactionBatchTypeAtomic
                                                                         error:nil];

    setupRecoveryAccountTransaction = [setupRecoveryAccountTransaction signedWithSignatories:@[self.adminSigner]
                                                                         signatoryPublicKeys:@[self.adminPublicKey]
                                                                                       error:nil];

    return [self.iroha executeBatchTransactions:@[clientToRecoveryPermissionsTransaction, recoveryToAdminPermissionsTransaction, setupRecoveryAccountTransaction]];
}

- (nonnull IRPromise*)grandClientToRecoveryPermissions {
    id<IRTransaction> transaction = [self createGrandClientToRecoveryPermissionsTransaction];
    return [self.iroha executeTransaction:transaction];
}

- (nonnull id<IRTransaction>)createGrandClientToRecoveryPermissionsTransaction {
    IRTransactionBuilder *builder = [IRTransactionBuilder builderWithCreatorAccountId:_clientAccount];
    builder = [builder grantPermission:_recoveryAccount permission:[IRGrantablePermissionFactory canAddMySignatory]];
    builder = [builder grantPermission:_recoveryAccount permission:[IRGrantablePermissionFactory canRemoveMySignatory]];

    id<IRTransaction> transaction = [[builder build:nil] signedWithSignatories:@[_clientSigner]
                                                           signatoryPublicKeys:@[_clientKeypair.publicKey]
                                                                         error:nil];

    return transaction;
}

- (nonnull IRPromise*)grandRecoveryToAdminPermissions {
    id<IRTransaction> transaction = [self createGrandRecoveryToAdminPermissionsTransaction];

    return [self.iroha executeTransaction:transaction];
}

- (nonnull id<IRTransaction>)createGrandRecoveryToAdminPermissionsTransaction {
    IRTransactionBuilder *builder = [IRTransactionBuilder builderWithCreatorAccountId:_recoveryAccount];
    builder = [builder grantPermission:self.adminAccountId permission:[IRGrantablePermissionFactory canAddMySignatory]];
    builder = [builder grantPermission:self.adminAccountId permission:[IRGrantablePermissionFactory canSetMyQuorum]];

    id<IRTransaction> transaction = [[builder build:nil] signedWithSignatories:@[_recoverySigner]
                                                           signatoryPublicKeys:@[_recoveryKeypair.publicKey]
                                                                         error:nil];

    return transaction;
}

- (nonnull IRPromise*)setupRecoveryAccount {
    id<IRTransaction> transaction = [self createSetupRecoveryAccountTransaction];
    return [self.iroha executeTransaction:transaction];
}

- (nonnull id<IRTransaction>)createSetupRecoveryAccountTransaction {
    IRTransactionBuilder *builder = [IRTransactionBuilder builderWithCreatorAccountId:self.adminAccountId];
    builder = [builder addSignatory:_recoveryAccount publicKey:self.adminPublicKey];
    builder = [builder setAccountQuorum:_recoveryAccount quorum:2];

    id<IRTransaction> transaction = [[builder build:nil] signedWithSignatories:@[self.adminSigner]
                                                           signatoryPublicKeys:@[self.adminPublicKey]
                                                                         error:nil];

    return transaction;
}

@end
