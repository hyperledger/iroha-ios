@import XCTest;
#import "IRBaseIrohaContainerTests.h"

@interface IRCancellableTests : IRBaseIrohaContainerTests

@end

@implementation IRCancellableTests

- (void)testCancelTransactionStreaming {
    NSData *transactionHash = [self validTransactionHash];

    XCTestExpectation *expectation = [[XCTestExpectation alloc] init];

    id<IRCancellable> call = [self.iroha streamTransactionStatus:transactionHash
                                                       withBlock:^(id<IRTransactionStatusResponse> response, BOOL done, NSError *error) {
                                                           XCTAssertTrue(done);

                                                           [expectation fulfill];
                                                       }];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [call cancel];
    });

    [self waitForExpectations:@[expectation] timeout:60.0];
}

- (void)testCancelBlockStreaming {
    XCTestExpectation *expectation = [[XCTestExpectation alloc] init];

    id<IRBlockQueryRequest> queryRequest = [[[IRBlockQueryBuilder builderWithCreatorAccountId:self.adminAccountId]
                                             build:nil]
                                            signedWithSignatory:self.adminSigner
                                            signatoryPublicKey:self.adminPublicKey
                                            error:nil];

    id<IRCancellable> call = [self.iroha streamCommits:queryRequest
                                             withBlock:^(id<IRBlockQueryResponse> response, BOOL done, NSError *error) {
                                                 XCTAssertTrue(done);

                                                 [expectation fulfill];
                                             }];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [call cancel];
    });

    [self waitForExpectations:@[expectation] timeout:60.0];
}

#pragma mark - Private

- (nonnull NSData*)validTransactionHash {
    id<IRAccountId> newAccountId = [IRAccountIdFactory accountIdWithName:@"new"
                                                                  domain:self.domain
                                                                   error:nil];

    id<IRCryptoKeypairProtocol> keypair = [[[IREd25519KeyFactory alloc] init] createRandomKeypair];

    IRTransactionBuilder* builder = [IRTransactionBuilder builderWithCreatorAccountId:self.adminAccountId];
    builder = [builder createAccount:newAccountId publicKey:keypair.publicKey];

    id<IRTransaction> transaction = [[builder build:nil] signedWithSignatories:@[self.adminSigner]
                                                              signatoryPublicKeys:@[self.adminPublicKey]
                                                                            error:nil];

    return [transaction transactionHashWithError:nil];
}

@end
