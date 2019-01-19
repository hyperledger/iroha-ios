#import "IRAssetResponse.h"

@implementation IRAssetResponse
@synthesize assetId = _assetId;
@synthesize precision = _precision;
@synthesize queryHash = _queryHash;

- (nonnull instancetype)initWithAssetId:(nonnull id<IRAssetId>)assetId
                              precision:(UInt32)precision
                              queryHash:(nonnull NSData*)queryHash {

    if (self = [super init]) {
        _assetId = assetId;
        _precision = precision;
        _queryHash = queryHash;
    }

    return self;
}

@end
