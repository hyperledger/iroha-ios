#import <Foundation/Foundation.h>
#import "IRBlockQueryResponse.h"

@interface IRBlock : NSObject<IRBlock>

- (nonnull instancetype)initWithHeight:(UInt64)height
                     previousBlockHash:(nullable NSData*)previousBlockHash
                             createdAt:(nonnull NSDate*)createdAt
                          transactions:(nonnull NSArray*)transactions
             rejectedTransactionHashes:(nonnull NSArray<NSData*>*)rejectedTransactionHashes
                        peerSignatures:(nonnull NSArray<id<IRPeerSignature>>*)peerSignatures;

@end
