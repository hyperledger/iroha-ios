#import <Foundation/Foundation.h>
#import "IRQueryResponse.h"

@interface IRAccountAssetsResponse : NSObject<IRAccountAssetsResponse>

- (nonnull instancetype)initWithAccountAssets:(nonnull NSArray<id<IRAccountAsset>>*)accountAssets
                                    queryHash:(nonnull NSData*)queryHash;

@end
