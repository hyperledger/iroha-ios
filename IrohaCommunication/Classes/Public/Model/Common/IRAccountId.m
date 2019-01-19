#import "IRAccountId.h"

static NSString * const ACCOUNT_NAME_FORMAT = @"[a-z_0-9]{1,32}";
static NSString * const ACCOUNT_SEPARATOR = @"@";

@interface IRAccountId : NSObject <IRAccountId>

- (instancetype)initWithName:(nonnull NSString*)name inDomain:(nonnull id<IRDomain>)domain;

@end

@implementation IRAccountId
@synthesize name = _name;
@synthesize domain = _domain;

- (instancetype)initWithName:(nonnull NSString*)name inDomain:(nonnull id<IRDomain>)domain {
    if (self = [super init]) {
        _name = name;
        _domain = domain;
    }

    return self;
}

- (nonnull NSString*)identifier {
    return [NSString stringWithFormat:@"%@%@%@", _name, ACCOUNT_SEPARATOR, _domain.identifier];
}

@end

@implementation IRAccountIdFactory

+ (nullable id<IRAccountId>)accountIdWithName:(nonnull NSString*)name
                                   domain:(nonnull id<IRDomain>)domain
                                        error:(NSError**)error {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", ACCOUNT_NAME_FORMAT];

    if ([predicate evaluateWithObject:name]) {
        return [[IRAccountId alloc] initWithName:name inDomain:domain];
    } else {
        if (error) {
            NSString *message = [NSString stringWithFormat:@"Account name %@ is invalid. Expected: %@", name, ACCOUNT_NAME_FORMAT];
            *error = [NSError errorWithDomain:NSStringFromClass([IRAccountIdFactory class])
                                         code:IRInvalidAccountName
                                     userInfo:@{NSLocalizedDescriptionKey: message}];
        }
        return nil;
    }
}

+ (nullable id<IRAccountId>)accountWithIdentifier:(nonnull NSString*)accountId
                                          error:(NSError**)error {
    NSArray<NSString*> *components = [accountId componentsSeparatedByString:ACCOUNT_SEPARATOR];

    if ([components count] != 2) {
        if (error) {
            NSString *message = [NSString stringWithFormat:@"Too many components are separated by %@ (expected 2) in %@", ACCOUNT_SEPARATOR, accountId];
            *error = [NSError errorWithDomain:NSStringFromClass([IRAccountIdFactory class])
                                         code:IRInvalidAccountIdentifier
                                     userInfo:@{NSLocalizedDescriptionKey: message}];
        }

        return nil;
    }

    id<IRDomain> domain = [IRDomainFactory domainWithIdentitifer:components[1] error:error];

    if (!domain) {
        return nil;
    }

    id<IRAccountId> account = [IRAccountIdFactory accountIdWithName:components[0] domain:domain error:error];

    if (!account) {
        return nil;
    }

    return account;
}

@end
