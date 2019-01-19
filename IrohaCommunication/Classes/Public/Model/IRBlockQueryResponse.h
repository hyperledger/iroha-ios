#ifndef IRBlockQueryResponse_h
#define IRBlockQueryResponse_h

#import "IRPeerSignature.h"
#import "IRTransaction.h"

@protocol IRBlock <NSObject>

@property(nonatomic, readonly)UInt64 height;
@property(nonatomic, readonly)NSData * _Nullable previousBlockHash;
@property(nonatomic, readonly)NSDate * _Nonnull createdAt;
@property(nonatomic, readonly)NSArray<id<IRTransaction>> * _Nonnull transactions;
@property(nonatomic, readonly)NSArray<NSData*> * _Nonnull rejectedTransactionHashes;
@property(nonatomic, readonly)NSArray<id<IRPeerSignature>> * _Nonnull peerSignatures;

@end

@protocol IRBlockQueryResponse <NSObject>

@property(nonatomic, readonly)id<IRBlock> _Nullable block;
@property(nonatomic, readonly)NSError * _Nullable error;

@end

#endif
