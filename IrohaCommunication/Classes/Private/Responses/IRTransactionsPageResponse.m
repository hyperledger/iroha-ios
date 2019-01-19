#import "IRTransactionsPageResponse.h"

@implementation IRTransactionsPageResponse
@synthesize transactions = _transactions;
@synthesize totalCount = _totalCount;
@synthesize nextTransactionHash = _nextTransactionHash;
@synthesize queryHash = _queryHash;

- (nonnull instancetype)initWithTransactions:(nonnull NSArray<id<IRTransaction>>*)transactions
                                  totalCount:(UInt32)totalCount
                         nextTransactionHash:(nullable NSData*)nextTransactionHash
                                   queryHash:(nonnull NSData*)queryHash {

    if (self = [super init]) {
        _transactions = transactions;
        _totalCount = totalCount;
        _nextTransactionHash = nextTransactionHash;
        _queryHash = queryHash;
    }

    return self;
}

@end
