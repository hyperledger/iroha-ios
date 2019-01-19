#import <Foundation/Foundation.h>
#import "IRCommand.h"
#import "IRProtobufTransformable.h"

@interface IRAddAssetQuantity : NSObject<IRAddAssetQuantity, IRProtobufTransformable>

- (nonnull instancetype)initWithAssetId:(nonnull id<IRAssetId>)assetId
                                 amount:(nonnull id<IRAmount>)amount;

@end
