#import <Foundation/Foundation.h>
#import "IRQueryResponse.h"

@interface IRTransactionsResponse : NSObject<IRTransactionsResponse>

- (nonnull instancetype)initWithTransactions:(nonnull NSArray<id<IRTransaction>>*)transactions
                                   queryHash:(nonnull NSData*)queryHash;

@end
