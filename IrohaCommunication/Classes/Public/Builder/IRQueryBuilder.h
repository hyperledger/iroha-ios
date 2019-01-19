#import <Foundation/Foundation.h>

#import "IRQueryRequest.h"

@protocol IRQueryBuilderProtocol <NSObject>

- (nonnull instancetype)withCreatorAccountId:(nonnull id<IRAccountId>)creatorAccountId;
- (nonnull instancetype)withCreatedDate:(nonnull NSDate*)date;
- (nonnull instancetype)withQueryCounter:(UInt64)queryCounter;
- (nonnull instancetype)withQuery:(nonnull id<IRQuery>)query;
- (nullable id<IRQueryRequest>)build:(NSError*_Nullable*_Nullable)error;

@end

typedef NS_ENUM(NSUInteger, IRQueryBuilderError) {
    IRQueryBuilderErrorMissingCreator,
    IRQueryBuilderErrorMissingQuery
};

@interface IRQueryBuilder : NSObject<IRQueryBuilderProtocol>

+ (nonnull instancetype)builderWithCreatorAccountId:(nonnull id<IRAccountId>)creator;

- (nonnull instancetype)getAccount:(nonnull id<IRAccountId>)accountId;

- (nonnull instancetype)getSignatories:(nonnull id<IRAccountId>)accountId;

- (nonnull instancetype)getAccountTransactions:(nonnull id<IRAccountId>)accountId
                                    pagination:(nullable id<IRPagination>)pagination;

- (nonnull instancetype)getAccountAssetTransactions:(nonnull id<IRAccountId>)accountId
                                            assetId:(nonnull id<IRAssetId>)assetId
                                         pagination:(nullable id<IRPagination>)pagination;

- (nonnull instancetype)getTransactions:(nonnull NSArray<NSData*>*)hashes;

- (nonnull instancetype)getAccountAssets:(nonnull id<IRAccountId>)accountId;

- (nonnull instancetype)getAccountDetail:(nullable id<IRAccountId>)accountId
                                  writer:(nullable id<IRAccountId>)writer
                                     key:(nullable NSString*)key;

- (nonnull instancetype)getRoles;

- (nonnull instancetype)getRolePermissions:(nonnull id<IRRoleName>)roleName;

- (nonnull instancetype)getAssetInfo:(nonnull id<IRAssetId>)assetId;

- (nonnull instancetype)getPendingTransactions;

@end
