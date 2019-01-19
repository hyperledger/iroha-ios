#import "IRTransactionsResponse.h"

@implementation IRTransactionsResponse
@synthesize transactions = _transactions;
@synthesize queryHash = _queryHash;

- (nonnull instancetype)initWithTransactions:(nonnull NSArray<id<IRTransaction>>*)transactions
                                   queryHash:(nonnull NSData*)queryHash {

    if (self = [super init]) {
        _transactions = transactions;
        _queryHash = queryHash;
    }

    return self;
}

@end
