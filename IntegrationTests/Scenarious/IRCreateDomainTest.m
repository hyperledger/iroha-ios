@import XCTest;
#import "IRBaseIrohaContainerTests.h"

@interface IRCreateDomainTest : IRBaseIrohaContainerTests

@end

@implementation IRCreateDomainTest

- (void)testCreateDomain {
    id<IRRoleName> userRole = [IRRoleNameFactory roleWithName:@"user"
                                                       error:nil];

    id<IRDomain> newDomain = [IRDomainFactory domainWithIdentitifer:@"newTestDomain" error:nil];

    IRTransactionBuilder *transactionBuilder = [IRTransactionBuilder builderWithCreatorAccountId:self.adminAccountId];
    transactionBuilder = [transactionBuilder createDomain:newDomain defaultRole:userRole];

    NSError *error = nil;
    id<IRTransaction> transaction = [[transactionBuilder build:&error]
                                     signedWithSignatories:@[self.adminSigner]
                                     signatoryPublicKeys:@[self.adminPublicKey]
                                     error:&error];

    if (!transaction) {
        XCTFail();
        return;
    }

    XCTestExpectation *expectation = [[XCTestExpectation alloc] init];

    [self.iroha executeTransaction:transaction].onThen(^IRPromise * _Nullable(id result) {
        if (!result) {
            XCTFail();
            return nil;
        }

        return [self.iroha onTransactionStatus:IRTransactionStatusCommitted withHash:result];
    }).onThen(^IRPromise * _Nullable(id result) {
        [expectation fulfill];
        return nil;
    }).onError(^IRPromise * _Nullable(NSError* error) {
        NSLog(@"%@", error);
        XCTFail();

        NSData *transactionHash = [transaction transactionHashWithError:nil];
        return [self.iroha fetchTransactionStatus:transactionHash];
    }).onThen(^IRPromise * _Nullable(id result) {
        if ([result conformsToProtocol:@protocol(IRTransactionStatusResponse)]) {
            id<IRTransactionStatusResponse> statusResponse = result;
            NSLog(@"Status: %@, Desc: %@", @(statusResponse.status), statusResponse.statusDescription);
        }

        [expectation fulfill];

        return nil;
    });

    [self waitForExpectations:@[expectation] timeout:60.0];
}

@end
