#import "IRAccountAsset.h"

@interface IRAccountAsset : NSObject<IRAccountAsset>

@end

@implementation IRAccountAsset
@synthesize accountId = _accountId;
@synthesize assetId = _assetId;
@synthesize balance = _balance;

- (nonnull instancetype)initWithAccountId:(nonnull id<IRAccountId>)accountId
                                  assetId:(nonnull id<IRAssetId>)assetId
                                   balance:(nonnull id<IRAmount>)balance {
    if (self = [super init]) {
        _accountId = accountId;
        _assetId = assetId;
        _balance = balance;
    }

    return self;
}

@end

@implementation IRAccountAssetFactory

+ (nullable id<IRAccountAsset>)accountAssetWithAccountId:(nonnull id<IRAccountId>)accountId
                                                 assetId:(nonnull id<IRAssetId>)assetId
                                                 balance:(nonnull id<IRAmount>)balance
                                                   error:(NSError *_Nullable*_Nullable)error {

    return [[IRAccountAsset alloc] initWithAccountId:accountId
                                             assetId:assetId
                                              balance:balance];
}

@end
