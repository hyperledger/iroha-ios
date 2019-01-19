#import <Foundation/Foundation.h>
#import "IRQueryResponse.h"

@interface IRAssetResponse : NSObject<IRAssetResponse>

- (nonnull instancetype)initWithAssetId:(nonnull id<IRAssetId>)assetId
                              precision:(UInt32)precision
                              queryHash:(nonnull NSData*)queryHash;

@end
