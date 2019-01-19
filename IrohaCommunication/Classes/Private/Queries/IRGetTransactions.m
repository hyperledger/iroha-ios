#import "IRGetTransactions.h"
#import "Queries.pbobjc.h"
#import <IrohaCrypto/NSData+Hex.h>

@implementation IRGetTransactions
@synthesize transactionHashes = _transactionHashes;

- (nonnull instancetype)initWithTransactionHashes:(nonnull NSArray<NSData*> *)hashes {
    if (self = [super init]) {
        _transactionHashes = hashes;
    }

    return self;
}

#pragma mark - Protobuf Transformable

- (nullable id)transform:(NSError**)error {
    GetTransactions *query = [[GetTransactions alloc] init];

    NSMutableArray<NSString*> *pbHashes = [NSMutableArray array];

    for (NSData *transactionHash in _transactionHashes) {
        [pbHashes addObject:[transactionHash toHexString]];
    }

    query.txHashesArray = pbHashes;

    Query_Payload *payload = [[Query_Payload alloc] init];
    payload.getTransactions = query;

    return payload;
}

@end
