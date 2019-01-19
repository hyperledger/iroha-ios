#import "IRTransferAsset.h"
#import "Commands.pbobjc.h"

@implementation IRTransferAsset
@synthesize sourceAccountId = _sourceAccountId;
@synthesize destinationAccountId = _destinationAccountId;
@synthesize assetId = _assetId;
@synthesize transferDescription = _transferDescription;
@synthesize amount = _amount;

- (nonnull instancetype)initWithSourceAccountId:(nonnull id<IRAccountId>)sourceAccountId
                           destinationAccountId:(nonnull id<IRAccountId>)destinationAccountId
                                        assetId:(nonnull id<IRAssetId>)assetId
                            transferDescription:(nonnull NSString*)transferDescription
                                         amount:(nonnull id<IRAmount>)amount {

    if (self = [super init]) {
        _sourceAccountId = sourceAccountId;
        _destinationAccountId = destinationAccountId;
        _assetId = assetId;
        _transferDescription = transferDescription;
        _amount = amount;
    }

    return self;
}

#pragma mark - Protobuf Transformable

- (nullable id)transform:(NSError *__autoreleasing *)error {
    TransferAsset *transferAsset = [[TransferAsset alloc] init];
    transferAsset.srcAccountId = [_sourceAccountId identifier];
    transferAsset.destAccountId = [_destinationAccountId identifier];
    transferAsset.assetId = [_assetId identifier];
    transferAsset.amount = [_amount value];
    transferAsset.description_p = _transferDescription;

    Command *command = [[Command alloc] init];
    command.transferAsset = transferAsset;

    return command;
}

@end
