#import <Foundation/Foundation.h>
#import "IRTransactionStatusResponseImpl.h"

@class ToriiResponse;

typedef NS_ENUM(NSUInteger, IRTransactionStatusResponseProtoError) {
    IRTransactionStatusResponseProtoErrorInvalidField
};

@interface IRTransactionStatusResponse (Proto)

+ (nullable instancetype)statusResponseWithToriiResponse:(nonnull ToriiResponse *)toriiResponse error:(NSError *_Nullable*_Nullable)error;

- (int32_t)protobufTransactionStatus;

@end
