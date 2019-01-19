#import <Foundation/Foundation.h>
#import "IRQuery.h"
#import "IRProtobufTransformable.h"

@interface IRGetAssetInfo : NSObject<IRGetAssetInfo, IRProtobufTransformable>

- (nonnull instancetype)initWithAssetId:(nonnull id<IRAssetId>)assetId;

@end
