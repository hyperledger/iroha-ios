#import "IRBlockQueryBuilder.h"
#import "IRBlockQueryRequestImpl.h"

static const UInt64 DEFAULT_QUERY_COUNTER = 1;

@interface IRBlockQueryBuilder()

@property(strong, nonatomic)id<IRAccountId> _Nullable creator;
@property(strong, nonatomic)NSDate* _Nullable createdAt;
@property(nonatomic, readwrite)UInt64 queryCounter;

@end

@implementation IRBlockQueryBuilder

#pragma mark - Initialization

- (nonnull instancetype)init {
    if (self = [super init]) {
        _queryCounter = DEFAULT_QUERY_COUNTER;
    }

    return self;
}

+ (nonnull instancetype)builderWithCreatorAccountId:(id<IRAccountId>)creator {
    return [[[IRBlockQueryBuilder alloc] init] withCreatorAccountId:creator];
}

#pragma mark - IRBlockQueryBuilderProtocol

- (nonnull instancetype)withCreatorAccountId:(nonnull id<IRAccountId>)creatorAccountId {
    _creator = creatorAccountId;

    return self;
}

- (nonnull instancetype)withCreatedDate:(nonnull NSDate*)date {
    _createdAt = date;

    return self;
}

- (nonnull instancetype)withQueryCounter:(UInt64)queryCounter {
    _queryCounter = queryCounter > 0 ? queryCounter : DEFAULT_QUERY_COUNTER;

    return self;
}

- (nullable id<IRBlockQueryRequest>)build:(NSError*_Nullable*_Nullable)error {
    if (!_creator) {
        if (error) {
            NSString *message = @"Creator's account id is required!";
            *error = [NSError errorWithDomain:NSStringFromClass([IRBlockQueryBuilder class])
                                         code:IRBlockQueryBuilderErrorMissingCreator
                                     userInfo:@{NSLocalizedDescriptionKey: message}];
        }

        return nil;
    }

    NSDate *createdAt = _createdAt ? _createdAt: [NSDate date];

    return [[IRBlockQueryRequest alloc] initWithCreator:_creator
                                               createdAt:createdAt
                                            queryCounter:_queryCounter
                                           peerSignature:nil];
}

@end
