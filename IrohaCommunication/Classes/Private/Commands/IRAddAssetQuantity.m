#import "IRAddAssetQuantity.h"
#import "Commands.pbobjc.h"

@implementation IRAddAssetQuantity
@synthesize assetId = _assetId;
@synthesize amount = _amount;

- (nonnull instancetype)initWithAssetId:(nonnull id<IRAssetId>)assetId
                                 amount:(nonnull id<IRAmount>)amount {
    if (self = [super init]) {
        _assetId = assetId;
        _amount = amount;
    }

    return self;
}

#pragma mark - Protobuf Transformable

- (nullable id)transform:(NSError**)error {
    AddAssetQuantity *assetQuantity = [[AddAssetQuantity alloc] init];
    assetQuantity.assetId = [_assetId identifier];
    assetQuantity.amount = [_amount value];

    Command *command = [[Command alloc] init];
    command.addAssetQuantity = assetQuantity;

    return command;
}

@end
