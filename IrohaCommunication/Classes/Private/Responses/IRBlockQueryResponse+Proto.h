#import "IRBlockQueryResponseImpl.h"

@class BlockQueryResponse;

typedef NS_ENUM(NSUInteger, IRBlockQueryResponseProtoError) {
    IRBlockQueryResponseProtoErrorInvalidField
};

@interface IRBlockQueryResponse (Proto)

+ (nullable IRBlockQueryResponse*)responseFromPbResponse:(nonnull BlockQueryResponse*)queryResponse
                                                   error:(NSError*_Nullable*_Nullable)error;

@end
