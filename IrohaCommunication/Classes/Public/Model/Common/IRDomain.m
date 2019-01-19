#import "IRDomain.h"

static NSString * const DOMAIN_FORMAT = @"([a-zA-Z]([a-zA-Z0-9\\-]{0,61}[a-zA-Z0-9])?\\.)*[a-zA-Z]([a-zA-Z0-9\\-]{0,61}[a-zA-Z0-9])?";

@interface IRDomain : NSObject<IRDomain>

- (instancetype)initWithIdentifier:(nonnull NSString*)identifier;

@end

@implementation IRDomain
@synthesize identifier = _identifier;

- (instancetype)initWithIdentifier:(nonnull NSString*)identifier {
    if (self = [super init]) {
        _identifier = identifier;
    }

    return self;
}

@end

@implementation IRDomainFactory

+ (nullable id<IRDomain>)domainWithIdentitifer:(nonnull NSString*)identifier error:(NSError**)error {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", DOMAIN_FORMAT];

    if ([predicate evaluateWithObject:identifier]) {
        return [[IRDomain alloc] initWithIdentifier:identifier];
    } else {
        if (error) {
            NSString *message = [NSString stringWithFormat:@"Domain %@ is invalid. Expected: %@", identifier, DOMAIN_FORMAT];
            *error = [NSError errorWithDomain:NSStringFromClass([IRDomainFactory class])
                                         code:IRInvalidDomainIdentifier
                                     userInfo:@{NSLocalizedDescriptionKey: message}];
        }

        return nil;
    }
}

@end
