#import "IRAddSignatory.h"
#import "Commands.pbobjc.h"
#import <IrohaCrypto/NSData+Hex.h>

@implementation IRAddSignatory
@synthesize accountId = _accountId;
@synthesize publicKey = _publicKey;

- (nonnull instancetype)initWithAccountId:(nonnull id<IRAccountId>)accountId
                                publicKey:(nonnull id<IRPublicKeyProtocol>)publicKey {

    if (self = [super init]) {
        _accountId = accountId;
        _publicKey = publicKey;
    }

    return self;
}

#pragma mark - Protobuf Transformable

- (nullable id)transform:(NSError *__autoreleasing *)error {
    AddSignatory *addSignatory = [[AddSignatory alloc] init];
    addSignatory.accountId = [_accountId identifier];
    addSignatory.publicKey = [_publicKey.rawData toHexString];

    Command *command = [[Command alloc] init];
    command.addSignatory = addSignatory;

    return command;
}

@end
