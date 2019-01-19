#import "IRBlockImpl.h"

@class Block;

typedef NS_ENUM(NSUInteger, IRBlockProtoError) {
    IRBlockProtoErrorInvalidField
};

@interface IRBlock (Proto)

+ (nullable id<IRBlock>)blockFromPbBlock:(nonnull Block*)block error:(NSError*_Nullable*_Nullable)error;

@end
