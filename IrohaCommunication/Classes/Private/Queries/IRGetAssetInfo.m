#import "IRGetAssetInfo.h"
#import "Queries.pbobjc.h"

@implementation IRGetAssetInfo
@synthesize assetId = _assetId;

- (nonnull instancetype)initWithAssetId:(nonnull id<IRAssetId>)assetId {
    if (self = [super init]) {
        _assetId = assetId;
    }

    return self;
}

#pragma mark - Protobuf Transformable

- (nullable id)transform:(NSError**)error {
    GetAssetInfo *query = [[GetAssetInfo alloc] init];
    query.assetId = [_assetId identifier];

    Query_Payload *payload = [[Query_Payload alloc] init];
    payload.getAssetInfo = query;

    return payload;
}

@end
