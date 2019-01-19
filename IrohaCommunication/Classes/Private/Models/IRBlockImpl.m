#import "IRBlockImpl.h"

@implementation IRBlock
@synthesize height = _height;
@synthesize previousBlockHash = _previousBlockHash;
@synthesize createdAt = _createdAt;
@synthesize transactions = _transactions;
@synthesize rejectedTransactionHashes = _rejectedTransactionHashes;
@synthesize peerSignatures = _peerSignatures;

- (nonnull instancetype)initWithHeight:(UInt64)height
                     previousBlockHash:(nullable NSData*)previousBlockHash
                             createdAt:(nonnull NSDate*)createdAt
                          transactions:(nonnull NSArray*)transactions
             rejectedTransactionHashes:(nonnull NSArray<NSData*>*)rejectedTransactionHashes
                        peerSignatures:(nonnull NSArray<id<IRPeerSignature>>*)peerSignatures {
    if (self = [super init]) {
        _height = height;
        _previousBlockHash = previousBlockHash;
        _createdAt = createdAt;
        _transactions = transactions;
        _rejectedTransactionHashes = rejectedTransactionHashes;
        _peerSignatures = peerSignatures;
    }

    return self;
}

@end
