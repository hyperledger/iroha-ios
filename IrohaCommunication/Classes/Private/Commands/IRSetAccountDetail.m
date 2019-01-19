#import "IRSetAccountDetail.h"
#import "Commands.pbobjc.h"

@implementation IRSetAccountDetail
@synthesize accountId = _accountId;
@synthesize key = _key;
@synthesize value = _value;

- (nonnull instancetype)initWithAccountId:(nonnull id<IRAccountId>)accountId
                                      key:(nonnull NSString*)key
                                    value:(nonnull NSString*)value {

    if (self = [super init]) {
        _accountId = accountId;
        _key = key;
        _value = value;
    }

    return self;
}

#pragma mark - Protobuf Transformable

- (nullable id)transform:(NSError *__autoreleasing *)error {
    SetAccountDetail *setAccountDetail = [[SetAccountDetail alloc] init];
    setAccountDetail.accountId = [_accountId identifier];
    setAccountDetail.key = _key;
    setAccountDetail.value = _value;

    Command *command = [[Command alloc] init];
    command.setAccountDetail = setAccountDetail;

    return command;
}

@end
