#import <Foundation/Foundation.h>
#import "IRTransaction.h"
#import "IRProtobufTransformable.h"

typedef NS_ENUM(NSUInteger, IRTransactionError) {
    IRTransactionErrorSigning,
    IRTransactionErrorSerialization,
    IRTransactionErrorHashing,
    IRTransactionErrorInvalidField
};

@interface IRTransaction : NSObject<IRTransaction, IRProtobufTransformable>

- (nonnull instancetype)initWithCreatorAccountId:(nonnull id<IRAccountId>)creatorAccountId
                                       createdAt:(nonnull NSDate*)createdAt
                                        commands:(nonnull NSArray<id<IRCommand>>*)commands
                                          quorum:(NSUInteger)quorum
                                      signatures:(nullable NSArray<id<IRPeerSignature>>*)signatures
                                     batchHashes:(nullable NSArray<NSData*>*)batchHashes
                                       batchType:(IRTransactionBatchType)batchType;

@end
