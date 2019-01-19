#import <Foundation/Foundation.h>
#import "IRQueryRequest.h"
#import "IRProtobufTransformable.h"

typedef NS_ENUM(NSUInteger, IRQueryRequestError) {
    IRQueryRequestErrorSigning,
    IRQueryRequestErrorSerialization
};

@interface IRQueryRequest : NSObject<IRQueryRequest, IRProtobufTransformable>

- (nonnull instancetype)initWithCreator:(nonnull id<IRAccountId>)creator
                              createdAt:(nonnull NSDate*)createdAt
                                  query:(nonnull id<IRQuery>)query
                           queryCounter:(UInt64)queryCounter
                          peerSignature:(nullable id<IRPeerSignature>)peerSignature;

@end
