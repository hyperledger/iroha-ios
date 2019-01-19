#import "IRCreateAccount.h"
#import "Commands.pbobjc.h"
#import <IrohaCrypto/NSData+Hex.h>

@implementation IRCreateAccount
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
    CreateAccount *createAccount = [[CreateAccount alloc] init];
    createAccount.accountName = _accountId.name;
    createAccount.domainId = [_accountId.domain identifier];
    createAccount.publicKey = [_publicKey.rawData toHexString];

    Command *command = [[Command alloc] init];
    command.createAccount = createAccount;

    return command;
}

@end
