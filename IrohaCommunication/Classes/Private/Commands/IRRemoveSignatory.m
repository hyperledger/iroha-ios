#import "IRRemoveSignatory.h"
#import "Commands.pbobjc.h"
#import <IrohaCrypto/NSData+Hex.h>

@implementation IRRemoveSignatory
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
    RemoveSignatory *removeSignatory = [[RemoveSignatory alloc] init];
    removeSignatory.accountId = [_accountId identifier];
    removeSignatory.publicKey = [_publicKey.rawData toHexString];

    Command *command = [[Command alloc] init];
    command.removeSignatory = removeSignatory;

    return command;
}

@end
