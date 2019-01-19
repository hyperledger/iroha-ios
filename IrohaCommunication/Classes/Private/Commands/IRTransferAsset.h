#import <Foundation/Foundation.h>
#import "IRCommand.h"
#import "IRProtobufTransformable.h"

@interface IRTransferAsset : NSObject<IRTransferAsset, IRProtobufTransformable>

- (nonnull instancetype)initWithSourceAccountId:(nonnull id<IRAccountId>)sourceAccountId
                           destinationAccountId:(nonnull id<IRAccountId>)destinationAccountId
                                        assetId:(nonnull id<IRAssetId>)assetId
                            transferDescription:(nonnull NSString*)transferDescription
                                         amount:(nonnull id<IRAmount>)amount;

@end
