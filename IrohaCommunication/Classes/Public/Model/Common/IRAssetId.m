#import "IRAssetId.h"

static NSString * const ASSET_NAME_FORMAT = @"[a-z_0-9]{1,32}";
static NSString * const ASSET_ID_SEPARATOR = @"#";

@interface IRAssetId : NSObject <IRAssetId>

- (instancetype)initWithName:(nonnull NSString*)name inDomain:(nonnull id<IRDomain>)domain;

@end

@implementation IRAssetId
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
    return [NSString stringWithFormat:@"%@%@%@", _name, ASSET_ID_SEPARATOR, _domain.identifier];
}

@end

@implementation IRAssetIdFactory

+ (nullable id<IRAssetId>)assetIdWithName:(nonnull NSString*)name
                                     domain:(nonnull id<IRDomain>)domain
                                    error:(NSError**)error {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", ASSET_NAME_FORMAT];

    if ([predicate evaluateWithObject:name]) {
        return [[IRAssetId alloc] initWithName:name inDomain:domain];
    } else {
        if (error) {
            NSString *message = [NSString stringWithFormat:@"Asset name %@ is invalid. Expected: %@", name, ASSET_NAME_FORMAT];
            *error = [NSError errorWithDomain:NSStringFromClass([IRAssetIdFactory class])
                                         code:IRInvalidAssetName
                                     userInfo:@{NSLocalizedDescriptionKey: message}];
        }
        
        return nil;
    }
}

+ (nullable id<IRAssetId>)assetWithIdentifier:(nonnull NSString*)assetId
                                            error:(NSError**)error {
    NSArray<NSString*> *components = [assetId componentsSeparatedByString:ASSET_ID_SEPARATOR];

    if ([components count] != 2) {
        if (error) {
            NSString *message = [NSString stringWithFormat:@"Too many components are separated by %@ (expected 2) in %@", ASSET_ID_SEPARATOR, assetId];
            *error = [NSError errorWithDomain:NSStringFromClass([IRAssetIdFactory class])
                                         code:IRInvalidAssetIdentifier
                                     userInfo:@{NSLocalizedDescriptionKey: message}];
        }

        return nil;
    }

    id<IRDomain> domain = [IRDomainFactory domainWithIdentitifer:components[1] error:error];

    if (!domain) {
        return nil;
    }

    id<IRAssetId> asset = [IRAssetIdFactory assetIdWithName:components[0] domain:domain error:error];

    if (!asset) {
        return nil;
    }

    return asset;
}

@end
