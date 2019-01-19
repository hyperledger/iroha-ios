#import "IRAddress.h"

static NSString * const IP_V4_FORMAT = @"((([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\\.){3}\
([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5]))";

static NSString * const PORT_FORMAT = @"6553[0-5]|655[0-2]\\d|65[0-4]\\d\\d|6[0-4]\\d{3}|[1-5]\\d{4}|[1-9]\\d{0,3}|0";

static NSString * const ADDRESS_PORT_SEPARATOR = @":";

static NSString * const DOMAIN_FORMAT = @"([a-zA-Z]([a-zA-Z0-9\\-]{0,61}[a-zA-Z0-9])?\\.)*[a-zA-Z]([a-zA-Z0-9\\-]{0,61}[a-zA-Z0-9])?";

@interface IRAddress : NSObject<IRAddress>

- (instancetype)initWithString:(nonnull NSString*)value;

@end

@implementation IRAddress
@synthesize value = _value;

- (instancetype)initWithString:(nonnull NSString*)value {
    if (self = [super init]) {
        _value = value;
    }

    return self;
}

#pragma mark - NSCopying

- (instancetype)copyWithZone:(NSZone *)zone {
    return [[IRAddress alloc] initWithString:_value];
}

@end

@implementation IRAddressFactory

+ (nullable id<IRAddress>)addressWithIp:(nonnull NSString*)ipV4 port:(nonnull NSString*)port error:(NSError**)error {
    if (![self isValidIpV4:ipV4]) {
        if (error) {
            NSString *message = [NSString stringWithFormat:@"IP address %@ is invalid. Expected: %@", ipV4, IP_V4_FORMAT];
            *error = [NSError errorWithDomain:NSStringFromClass([IRAddressFactory class])
                                         code:IRInvalidAddressIp
                                     userInfo:@{NSLocalizedDescriptionKey: message}];
        }

        return nil;
    }

    if (![self isValidPort:port]) {
        if (error) {
            NSString *message = [NSString stringWithFormat:@"Address %@ is invalid. Expected: %@", port, PORT_FORMAT];
            *error = [NSError errorWithDomain:NSStringFromClass([IRAddressFactory class])
                                         code:IRInvalidAddressPort
                                     userInfo:@{NSLocalizedDescriptionKey: message}];
        }
        return nil;
    }

    NSString *value = [NSString stringWithFormat:@"%@%@%@", ipV4, ADDRESS_PORT_SEPARATOR, port];
    return [[IRAddress alloc] initWithString:value];
}

+ (nullable id<IRAddress>)addressWithDomain:(nonnull NSString*)domain port:(nonnull NSString*)port error:(NSError**)error {
    if (![self isValidDomain:domain]) {
        if (error) {
            NSString *message = [NSString stringWithFormat:@"Domain %@ is invalid. Expected: %@", domain, DOMAIN_FORMAT];
            *error = [NSError errorWithDomain:NSStringFromClass([IRAddressFactory class])
                                         code:IRInvalidAddressDomain
                                     userInfo:@{NSLocalizedDescriptionKey: message}];
        }

        return nil;
    }

    if (![self isValidPort:port]) {
        if (error) {
            NSString *message = [NSString stringWithFormat:@"Address %@ is invalid. Expected: %@", port, PORT_FORMAT];
            *error = [NSError errorWithDomain:NSStringFromClass([IRAddressFactory class])
                                         code:IRInvalidAddressPort
                                     userInfo:@{NSLocalizedDescriptionKey: message}];
        }
        return nil;
    }

    NSString *value = [NSString stringWithFormat:@"%@%@%@", domain, ADDRESS_PORT_SEPARATOR, port];

    return [[IRAddress alloc] initWithString:value];
}

+ (nullable id<IRAddress>)addressWithValue:(nonnull NSString*)value error:(NSError**)error {
    NSArray<NSString*> *components = [value componentsSeparatedByString:ADDRESS_PORT_SEPARATOR];

    if ([components count] != 2) {
        if (error) {
            *error = [self invalidValueError:value];
        }
        return nil;
    }

    id<IRAddress> address = [self addressWithIp:components[0]
                                           port:components[1]
                                          error:error];

    if (address) {
        return address;
    }

    address = [self addressWithDomain:components[0]
                                 port:components[1]
                                error:error];

    if (!address && error) {
        *error = [self invalidValueError:value];
    }

    return address;
}

+ (BOOL)isValidIpV4:(nonnull NSString*)ipV4 {
    return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", IP_V4_FORMAT] evaluateWithObject:ipV4];
}

+ (BOOL)isValidPort:(nonnull NSString*)port {
    return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", PORT_FORMAT] evaluateWithObject:port];
}

+ (BOOL)isValidDomain:(nonnull NSString*)domain {
    return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", DOMAIN_FORMAT] evaluateWithObject:domain];
}

+ (nonnull NSError*)invalidValueError:(nonnull NSString*)value {
    NSString *message = [NSString stringWithFormat:@"Invalid address value: %@", value];
    return [NSError errorWithDomain:NSStringFromClass([IRAddressFactory class])
                               code:IRInvalidAddressValue
                           userInfo:@{NSLocalizedDescriptionKey: message}];
}

@end
