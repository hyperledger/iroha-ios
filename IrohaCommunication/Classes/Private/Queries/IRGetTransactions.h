#import <Foundation/Foundation.h>
#import "IRQuery.h"
#import "IRProtobufTransformable.h"

@interface IRGetTransactions : NSObject<IRGetTransactions, IRProtobufTransformable>

- (nonnull instancetype)initWithTransactionHashes:(nonnull NSArray<NSData*> *)hashes;

@end
