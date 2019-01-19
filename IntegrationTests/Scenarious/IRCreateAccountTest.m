@import XCTest;
#import "IRBaseIrohaContainerTests.h"

@interface IRCreateAccountTest : IRBaseIrohaContainerTests

@end

@implementation IRCreateAccountTest

- (void)testCreateAccount {
    id<IRAccountId> newAccountId = [IRAccountIdFactory accountIdWithName:@"new"
                                                                  domain:self.domain
                                                                   error:nil];

    id<IRCryptoKeypairProtocol> keypair = [[[IREd25519KeyFactory alloc] init] createRandomKeypair];

    id<IRSignatureCreatorProtocol> newAccountSigner = [[IREd25519Sha512Signer alloc] initWithPrivateKey:keypair.privateKey];

    IRTransactionBuilder* builder = [IRTransactionBuilder builderWithCreatorAccountId:self.adminAccountId];
    builder = [builder createAccount:newAccountId publicKey:keypair.publicKey];

    NSError *error = nil;
    id<IRTransaction> transaction = [[builder build:&error] signedWithSignatories:@[self.adminSigner]
                                                              signatoryPublicKeys:@[self.adminPublicKey]
                                                                            error:&error];

    if (!transaction) {
        XCTFail();
        return;
    }

    XCTestExpectation *expectation = [[XCTestExpectation alloc] init];

    UInt32 quorum = 2;

    [self.iroha executeTransaction:transaction].onThen(^IRPromise * _Nullable(id result) {
        return [self.iroha onTransactionStatus:IRTransactionStatusCommitted withHash:result];
    }).onThen(^IRPromise * _Nullable(id result) {
        IRTransactionBuilder *transactionBuilder = [IRTransactionBuilder builderWithCreatorAccountId:newAccountId];
        transactionBuilder = [transactionBuilder addSignatory:newAccountId publicKey:self.adminPublicKey];
        transactionBuilder = [transactionBuilder setAccountQuorum:newAccountId quorum:quorum];

        NSError *error = nil;
        id<IRTransaction> transaction = [[transactionBuilder build:&error] signedWithSignatories:@[newAccountSigner]
                                                                             signatoryPublicKeys:@[keypair.publicKey]
                                                                                           error:&error];

        return [self.iroha executeTransaction:transaction];
    }).onThen(^IRPromise * _Nullable(id result) {
        return [self.iroha onTransactionStatus:IRTransactionStatusCommitted withHash:result];
    }).onThen(^IRPromise * _Nullable(id result) {
        IRQueryBuilder *queryBuilder = [IRQueryBuilder builderWithCreatorAccountId:self.adminAccountId];
        queryBuilder = [queryBuilder getAccount:newAccountId];

        NSError *queryError = nil;
        id<IRQueryRequest> queryRequest = [[queryBuilder build:&queryError] signedWithSignatory:self.adminSigner
                                                               signatoryPublicKey:self.adminPublicKey
                                                                            error:&queryError];

        return [self.iroha executeQueryRequest:queryRequest];
    }).onThen(^IRPromise * _Nullable(id result) {
        if (![result conformsToProtocol:@protocol(IRAccountResponse)]) {
            XCTFail();
        } else {
            id<IRAccountResponse> accountResponse = result;
            XCTAssertEqualObjects(accountResponse.accountId.identifier, newAccountId.identifier);
        }

        [expectation fulfill];

        return nil;
    }).onError(^IRPromise * _Nullable(NSError* error) {
        XCTFail();
        NSLog(@"%@",error);

        [expectation fulfill];

        return nil;
    });

    [self waitForExpectations:@[expectation] timeout:60.0];
}

@end
