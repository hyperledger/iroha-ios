#import <Foundation/Foundation.h>
#import "IRBlockQueryRequest.h"

@protocol IRBlockQueryBuilderProtocol <NSObject>

- (nonnull instancetype)withCreatorAccountId:(nonnull id<IRAccountId>)creatorAccountId;
- (nonnull instancetype)withCreatedDate:(nonnull NSDate*)date;
- (nonnull instancetype)withQueryCounter:(UInt64)queryCounter;
- (nullable id<IRBlockQueryRequest>)build:(NSError*_Nullable*_Nullable)error;

@end

typedef NS_ENUM(NSUInteger, IRBlockQueryBuilderError) {
    IRBlockQueryBuilderErrorMissingCreator
};

@interface IRBlockQueryBuilder : NSObject<IRBlockQueryBuilderProtocol>

+ (nonnull instancetype)builderWithCreatorAccountId:(nonnull id<IRAccountId>)creator;

@end
