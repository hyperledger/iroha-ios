#ifndef IRTransaction_h
#define IRTransaction_h

#import "IRCommand.h"
#import "IRSignable.h"
#import "IRPeerSignature.h"
#import <IrohaCrypto/IRSignature.h>

typedef NS_ENUM(NSUInteger, IRTransactionBatchType) {
    IRTransactionBatchTypeNone,
    IRTransactionBatchTypeAtomic,
    IRTransactionBatchTypeOrdered
};

@protocol IRTransaction <NSObject, IRSignable>

@property(nonatomic, readonly)id<IRAccountId> _Nonnull creator;
@property(nonatomic, readonly)NSDate* _Nonnull createdAt;
@property(nonatomic, readonly)NSArray<id<IRCommand>>* _Nonnull commands;
@property(nonatomic, readonly)NSUInteger quorum;
@property(nonatomic, readonly)NSArray<id<IRPeerSignature>>* _Nullable signatures;
@property(nonatomic, readonly)NSArray<NSData*>* _Nullable batchHashes;
@property(nonatomic, readonly)IRTransactionBatchType batchType;

- (nullable NSData*)transactionHashWithError:(NSError **)error;

- (nullable NSData*)batchHashWithError:(NSError **)error;

- (nullable instancetype)signedWithSignatories:(nonnull NSArray<id<IRSignatureCreatorProtocol>>*)signatories
                           signatoryPublicKeys:(nonnull NSArray<id<IRPublicKeyProtocol>> *)signatoryPublicKeys
                                         error:(NSError**)error;

- (nullable instancetype)batched:(nullable NSArray<NSData*>*)transactionBatchHashes
                       batchType:(IRTransactionBatchType)batchType
                           error:(NSError**)error;

@end

#endif /* IRTransaction_h */
