#import "IRCreateAsset.h"
#import "Commands.pbobjc.h"

@implementation IRCreateAsset
@synthesize assetId = _assetId;
@synthesize precision = _precision;

- (nonnull instancetype)initWithAssetId:(nonnull id<IRAssetId>)assetId
                              precision:(UInt32)precision {

    if (self = [super init]) {
        _assetId = assetId;
        _precision = precision;
    }

    return self;
}

#pragma mark - Protobuf Transformable

- (nullable id)transform:(NSError *__autoreleasing *)error {
    CreateAsset *createAsset = [[CreateAsset alloc] init];
    createAsset.assetName = [_assetId name];
    createAsset.domainId = [_assetId.domain identifier];
    createAsset.precision = _precision;

    Command *command = [[Command alloc] init];
    command.createAsset = createAsset;

    return command;
}

@end
