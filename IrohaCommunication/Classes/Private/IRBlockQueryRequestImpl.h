#import <Foundation/Foundation.h>
#import "IRBlockQueryRequest.h"
#import "IRProtobufTransformable.h"

typedef NS_ENUM(NSUInteger, IRQueryRequestError) {
    IRQueryRequestErrorSigning,
    IRQueryRequestErrorSerialization
};

@interface IRBlockQueryRequest : NSObject<IRBlockQueryRequest, IRProtobufTransformable>

- (nonnull instancetype)initWithCreator:(nonnull id<IRAccountId>)creator
                              createdAt:(nonnull NSDate*)createdAt
                           queryCounter:(UInt64)queryCounter
                          peerSignature:(nullable id<IRPeerSignature>)peerSignature;

@end
