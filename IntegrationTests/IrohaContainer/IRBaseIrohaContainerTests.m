#import "IRBaseIrohaContainerTests.h"
#import "IRIrohaContainer.h"

@implementation IRBaseIrohaContainerTests

- (nonnull IRNetworkService*)iroha {
    return [IRIrohaContainer.shared iroha];
}

- (void)setUp {
    [super setUp];

    NSError *error = nil;
    error = [IRIrohaContainer.shared start];

    if (error) {
        NSLog(@"%@", error);
        return;
    }

    [self initializePrimitives];
}

- (void)tearDown {
    [super tearDown];

    NSError *error = nil;
    error = [IRIrohaContainer.shared stop];

    if (error) {
        NSLog(@"%@", error);
    }
}

#pragma mark - Private

- (void)initializePrimitives {
    _domain = [IRDomainFactory domainWithIdentitifer:@"test" error:nil];
    _adminAccountId = [IRAccountIdFactory accountIdWithName:@"admin"
                                                     domain:_domain
                                                      error:nil];

    NSData *rawPublicKey = [[NSData alloc] initWithHexString:@"313a07e6384776ed95447710d15e59148473ccfc052a681317a72a69f2a49910"];
    NSData *rawPrivateKey = [[NSData alloc] initWithHexString:@"f101537e319568c765b2cc89698325604991dca57b9716b58016b253506cab70"];

    _adminPublicKey = [[IREd25519PublicKey alloc] initWithRawData:rawPublicKey];

    id<IRPrivateKeyProtocol> adminPrivateKey = [[IREd25519PrivateKey alloc] initWithRawData:rawPrivateKey];
    _adminSigner = [[IREd25519Sha512Signer alloc] initWithPrivateKey:adminPrivateKey];
}

@end
