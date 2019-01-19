#import <Foundation/Foundation.h>
#import "IRTransaction.h"
#import "IRQueryRequest.h"
#import "IRTransactionStatusResponse.h"
#import "IRPromise.h"
#import "IRBlockQueryRequest.h"
#import "IRBlockQueryResponse.h"
#import "IRCancellable.h"

typedef void (^IRTransactionStatusBlock)(id<IRTransactionStatusResponse> _Nullable response, BOOL done, NSError * _Nullable error);
typedef void (^IRCommitStreamBlock)(id<IRBlockQueryResponse> _Nullable response, BOOL done, NSError * _Nullable error);

typedef NS_ENUM(NSUInteger, IRNetworkServiceError) {
    IRNetworkServiceErrorTransactionStatusNotReceived
};

@interface IRNetworkService : NSObject

@property(strong, nonatomic)dispatch_queue_t _Nonnull responseSerialQueue;

- (nonnull instancetype)initWithAddress:(nonnull id<IRAddress>)address;

- (nonnull instancetype)initWithAddress:(nonnull id<IRAddress>)address useSecuredConnection:(BOOL)secured;

- (nonnull IRPromise *)executeTransaction:(nonnull id<IRTransaction>)transaction;

- (nonnull IRPromise *)onTransactionStatus:(IRTransactionStatus)transactionStatus
                                  withHash:(nonnull NSData*)transactionHash;

- (nonnull IRPromise *)fetchTransactionStatus:(nonnull NSData*)transactionHash;

- (nullable id<IRCancellable>)streamTransactionStatus:(nonnull NSData*)transactionHash
                                            withBlock:(nonnull IRTransactionStatusBlock)block;

- (nonnull IRPromise*)executeQueryRequest:(nonnull id<IRQueryRequest>)queryRequest;

- (nullable id<IRCancellable>)streamCommits:(nonnull id<IRBlockQueryRequest>)request
                                  withBlock:(nonnull IRCommitStreamBlock)block;

@end
