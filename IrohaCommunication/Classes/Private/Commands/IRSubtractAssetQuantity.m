#import "IRSubtractAssetQuantity.h"
#import "Commands.pbobjc.h"

@implementation IRSubtractAssetQuantity
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

- (nullable id)transform:(NSError *__autoreleasing *)error {
    SubtractAssetQuantity *subtractAssetQuantity = [[SubtractAssetQuantity alloc] init];
    subtractAssetQuantity.assetId = [_assetId identifier];
    subtractAssetQuantity.amount = [_amount value];

    Command *command = [[Command alloc] init];
    command.subtractAssetQuantity = subtractAssetQuantity;

    return command;
}

@end
