#import <Foundation/Foundation.h>
#import "IRAccountId.h"
#import "IRAssetId.h"
#import "IRAmount.h"

@protocol IRAccountAsset <NSObject>

@property(nonatomic, readonly)id<IRAccountId> _Nonnull accountId;
@property(nonatomic, readonly)id<IRAssetId> _Nonnull assetId;
@property(nonatomic, readonly)id<IRAmount> _Nonnull balance;

@end

@protocol IRAccountAssetFactoryProtocol <NSObject>

+ (nullable id<IRAccountAsset>)accountAssetWithAccountId:(nonnull id<IRAccountId>)accountId
                                                 assetId:(nonnull id<IRAssetId>)assetId
                                                  balance:(nonnull id<IRAmount>)balance
                                                   error:(NSError *_Nullable*_Nullable)error;

@end

@interface IRAccountAssetFactory : NSObject<IRAccountAssetFactoryProtocol>

@end
