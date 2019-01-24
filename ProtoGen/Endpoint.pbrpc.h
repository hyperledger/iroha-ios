#if !defined(GPB_GRPC_FORWARD_DECLARE_MESSAGE_PROTO) || !GPB_GRPC_FORWARD_DECLARE_MESSAGE_PROTO
#import "Endpoint.pbobjc.h"
#endif

#if !defined(GPB_GRPC_PROTOCOL_ONLY) || !GPB_GRPC_PROTOCOL_ONLY
#import <ProtoRPC/ProtoService.h>
#import <ProtoRPC/ProtoRPC.h>
#import <RxLibrary/GRXWriteable.h>
#import <RxLibrary/GRXWriter.h>
#endif

#if defined(GPB_GRPC_FORWARD_DECLARE_MESSAGE_PROTO) && GPB_GRPC_FORWARD_DECLARE_MESSAGE_PROTO
  @class BlockQueryResponse;
  @class BlocksQuery;
  @class GPBEmpty;
  @class Query;
  @class QueryResponse;
  @class ToriiResponse;
  @class Transaction;
  @class TxList;
  @class TxStatusRequest;
#else
  #import "Transaction.pbobjc.h"
  #import "Queries.pbobjc.h"
  #import "QryResponses.pbobjc.h"
#if defined(GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS) && GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS
  #import <Protobuf/Empty.pbobjc.h>
#else
  #import "google/protobuf/Empty.pbobjc.h"
#endif
#endif

@class GRPCProtoCall;


NS_ASSUME_NONNULL_BEGIN

@protocol CommandService_v1 <NSObject>

#pragma mark Torii(Transaction) returns (Empty)

- (void)toriiWithRequest:(Transaction *)request handler:(void(^)(GPBEmpty *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToToriiWithRequest:(Transaction *)request handler:(void(^)(GPBEmpty *_Nullable response, NSError *_Nullable error))handler;


#pragma mark ListTorii(TxList) returns (Empty)

- (void)listToriiWithRequest:(TxList *)request handler:(void(^)(GPBEmpty *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToListToriiWithRequest:(TxList *)request handler:(void(^)(GPBEmpty *_Nullable response, NSError *_Nullable error))handler;


#pragma mark Status(TxStatusRequest) returns (ToriiResponse)

- (void)statusWithRequest:(TxStatusRequest *)request handler:(void(^)(ToriiResponse *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToStatusWithRequest:(TxStatusRequest *)request handler:(void(^)(ToriiResponse *_Nullable response, NSError *_Nullable error))handler;


#pragma mark StatusStream(TxStatusRequest) returns (stream ToriiResponse)

- (void)statusStreamWithRequest:(TxStatusRequest *)request eventHandler:(void(^)(BOOL done, ToriiResponse *_Nullable response, NSError *_Nullable error))eventHandler;

- (GRPCProtoCall *)RPCToStatusStreamWithRequest:(TxStatusRequest *)request eventHandler:(void(^)(BOOL done, ToriiResponse *_Nullable response, NSError *_Nullable error))eventHandler;


@end

@protocol QueryService_v1 <NSObject>

#pragma mark Find(Query) returns (QueryResponse)

- (void)findWithRequest:(Query *)request handler:(void(^)(QueryResponse *_Nullable response, NSError *_Nullable error))handler;

- (GRPCProtoCall *)RPCToFindWithRequest:(Query *)request handler:(void(^)(QueryResponse *_Nullable response, NSError *_Nullable error))handler;


#pragma mark FetchCommits(BlocksQuery) returns (stream BlockQueryResponse)

- (void)fetchCommitsWithRequest:(BlocksQuery *)request eventHandler:(void(^)(BOOL done, BlockQueryResponse *_Nullable response, NSError *_Nullable error))eventHandler;

- (GRPCProtoCall *)RPCToFetchCommitsWithRequest:(BlocksQuery *)request eventHandler:(void(^)(BOOL done, BlockQueryResponse *_Nullable response, NSError *_Nullable error))eventHandler;


@end


#if !defined(GPB_GRPC_PROTOCOL_ONLY) || !GPB_GRPC_PROTOCOL_ONLY
/**
 * Basic service implementation, over gRPC, that only does
 * marshalling and parsing.
 */
@interface CommandService_v1 : GRPCProtoService<CommandService_v1>
- (instancetype)initWithHost:(NSString *)host NS_DESIGNATED_INITIALIZER;
+ (instancetype)serviceWithHost:(NSString *)host;
@end
/**
 * Basic service implementation, over gRPC, that only does
 * marshalling and parsing.
 */
@interface QueryService_v1 : GRPCProtoService<QueryService_v1>
- (instancetype)initWithHost:(NSString *)host NS_DESIGNATED_INITIALIZER;
+ (instancetype)serviceWithHost:(NSString *)host;
@end
#endif

NS_ASSUME_NONNULL_END

