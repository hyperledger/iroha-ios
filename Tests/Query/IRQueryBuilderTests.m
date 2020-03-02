/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

@import XCTest;
@import IrohaCommunication;


static NSString * const VALID_ACCOUNT_IDENTIFIER = @"bob@gmail.com";
static NSString * const VALID_WRITER_IDENTIFIER = @"writer@test";
static NSString * const VALID_ASSET_IDENTIFIER = @"testcoin#gmail.com";
static NSString * const VALID_ROLE = @"admin";
static NSString * const DETAIL_KEY = @"key";
static UInt64 VALID_QUERY_COUNTER = 10;
static UInt32 DETAIL_PAGE_SIZE = 10;


@interface IRQueryTestCase : NSObject

@property (nonatomic, readonly) SEL selector;
@property (nonatomic, readonly) NSArray *arguments;
@property (nonatomic, readonly) Protocol *protocol;

@end


@implementation IRQueryTestCase

- (nonnull instancetype)initWithSelector:(nonnull SEL)selector
                               arguments:(nullable NSArray*)arguments
                                protocol:(Protocol*)protocol {
    if (self = [super init]) {
        _selector = selector;
        _arguments = arguments;
        _protocol = protocol;
    }

    return self;
}

@end

@interface IRQueryTests : XCTestCase

@end

@implementation IRQueryTests

- (void)testMissingAccountId {
    IRQueryBuilder *queryBuilder = [[IRQueryBuilder alloc] init];

    NSError *error = nil;
    id<IRQueryRequest> query = [queryBuilder build:&error];

    XCTAssertNil(query);
    XCTAssertTrue(error && error.code == IRQueryBuilderErrorMissingCreator);
}

- (void)testMissingQuery {
    id<IRAccountId> accountId = [IRAccountIdFactory accountWithIdentifier:VALID_ACCOUNT_IDENTIFIER
                                                                    error:nil];

    IRQueryBuilder *queryBuilder = [IRQueryBuilder builderWithCreatorAccountId:accountId];

    NSError *error = nil;
    id<IRQueryRequest> query = [queryBuilder build:&error];

    XCTAssertNil(query);
    XCTAssertTrue(error && error.code == IRQueryBuilderErrorMissingQuery);
}

- (void)testQueries {
    id<IRAccountId> accountId = [IRAccountIdFactory accountWithIdentifier:VALID_ACCOUNT_IDENTIFIER
                                                                    error:nil];

    NSDate *date = [NSDate date];

    NSArray<IRQueryTestCase*> *testCases = [self createTestCases];

    for(IRQueryTestCase *testCase in testCases) {
        IRQueryBuilder *queryBuilder = [IRQueryBuilder builderWithCreatorAccountId:accountId];
        queryBuilder = [queryBuilder withCreatedDate:date];
        queryBuilder = [queryBuilder withQueryCounter:VALID_QUERY_COUNTER];

        NSMethodSignature *methodSignature = [queryBuilder methodSignatureForSelector:testCase.selector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
        invocation.selector = testCase.selector;
        invocation.target = queryBuilder;

        if (testCase.arguments.count > 0) {
            for (NSUInteger argumentIndex = 0; argumentIndex < testCase.arguments.count; argumentIndex++) {
                id argument = testCase.arguments[argumentIndex];
                [invocation setArgument:&(argument) atIndex:argumentIndex + 2];
            }
        }

        [invocation invoke];

        NSError *error = nil;
        id<IRQueryRequest> queryRequest = [queryBuilder build:&error];

        XCTAssertNil(error, "Query builder failed: %@", [error localizedDescription]);
        XCTAssertNotNil(queryRequest);
        XCTAssertEqualObjects([accountId identifier], [queryRequest.creator identifier]);
        XCTAssertEqualObjects(date, queryRequest.createdAt);
        XCTAssertEqual(VALID_QUERY_COUNTER, queryRequest.queryCounter);
        XCTAssertTrue([queryRequest.query conformsToProtocol:testCase.protocol]);
        XCTAssertNil(queryRequest.peerSignature);

        error = nil;

        id<IRCryptoKeypairProtocol> keypair = [[[IRIrohaKeyFactory alloc] init] createRandomKeypair:&error];

        XCTAssertNil(error, "Iroha key factory error: %@", [error localizedDescription]);

        id<IRSignatureCreatorProtocol> signatory = [[IRIrohaSigner alloc] initWithPrivateKey:[keypair privateKey]];

        error = nil;

        id<IRQueryRequest> signedQueryRequest = [queryRequest signedWithSignatory:signatory
                                                               signatoryPublicKey:keypair.publicKey
                                                                            error:&error];

        XCTAssertNotNil(signedQueryRequest.peerSignature);
        XCTAssertNil(error, "Signing failed: %@", [error localizedDescription]);

        error = nil;

        NSData *rawQueryRequestData = [IRSerializationFactory serializeQueryRequest:signedQueryRequest
                                                                              error:&error];

        XCTAssertNotNil(rawQueryRequestData);
        XCTAssertNil(error, "Serialization failed: %@", [error localizedDescription]);
    }
    
}

- (nonnull NSArray<IRQueryTestCase*>*)createTestCases {
    id<IRAccountId> accountId = [IRAccountIdFactory accountWithIdentifier:VALID_ACCOUNT_IDENTIFIER
                                                                    error:nil];
    
    id<IRAssetId> assetId = [IRAssetIdFactory assetWithIdentifier:VALID_ASSET_IDENTIFIER
                                                            error:nil];
    
    id<IRRoleName> roleName = [IRRoleNameFactory roleWithName:VALID_ROLE
                                                        error:nil];
    
    id<IRPagination> pagination = [IRPaginationFactory pagination:10
                                                    firstItemHash:nil
                                                            error:nil];

    id<IRAssetPagination> assetPagination = [IRAssetPaginationFactory assetPagination:DETAIL_PAGE_SIZE startingAssetId:assetId];
    
    id<IRAccountDetailRecordId> accountDetailRecordId = [IRAccountDetailRecordIdFactory accountDetailRecordIdWithWriter:VALID_WRITER_IDENTIFIER
                                                                                                                    key:DETAIL_KEY];
    
    id<IRAccountDetailPagination> accountDetailPagination = [IRAccountDetailPaginationFactory accountDetailPagination:DETAIL_PAGE_SIZE
                                                                                                         nextRecordId:accountDetailRecordId];

    NSData *itemHash = [@"Test Data" dataUsingEncoding:NSUTF8StringEncoding];

    IRQueryTestCase *getAccountTestCase = [[IRQueryTestCase alloc] initWithSelector:@selector(getAccount:)
                                                                          arguments:@[accountId]
                                                                           protocol:@protocol(IRGetAccount)];

    IRQueryTestCase *getSignatories = [[IRQueryTestCase alloc] initWithSelector:@selector(getSignatories:)
                                                                      arguments:@[accountId]
                                                                       protocol:@protocol(IRGetSignatories)];

    IRQueryTestCase *getAccountTransactions = [[IRQueryTestCase alloc] initWithSelector:@selector(getAccountTransactions:pagination:)
                                                                              arguments:@[accountId, pagination]
                                                                               protocol:@protocol(IRGetAccountTransactions)];

    IRQueryTestCase *getAccountAssetTransactions = [[IRQueryTestCase alloc] initWithSelector:@selector(getAccountAssetTransactions:assetId:pagination:)
                                                                                   arguments:@[accountId, assetId]
                                                                                    protocol:@protocol(IRGetAccountAssetTransactions)];

    IRQueryTestCase *getTransactions = [[IRQueryTestCase alloc] initWithSelector:@selector(getTransactions:)
                                                                       arguments:@[@[itemHash]]
                                                                        protocol:@protocol(IRGetTransactions)];

    IRQueryTestCase *getAccountAssets = [[IRQueryTestCase alloc] initWithSelector:@selector(getAccountAssets:)
                                                                       arguments:@[accountId]
                                                                        protocol:@protocol(IRGetAccountAssets)];

    IRQueryTestCase *getAccountAssetsPaginated = [[IRQueryTestCase alloc] initWithSelector:@selector(getAccountAssets:pagination:)
                                                                              arguments:@[accountId, assetPagination]
                                                                               protocol:@protocol(IRGetAccountAssets)];

    IRQueryTestCase *getAccountDetail = [[IRQueryTestCase alloc] initWithSelector:@selector(getAccountDetail:pagination:)
                                                                        arguments:@[accountId, accountDetailPagination]
                                                                         protocol:@protocol(IRGetAccountDetail)];
    
    IRQueryTestCase *getAccountDetailPaginated = [[IRQueryTestCase alloc] initWithSelector:@selector(getAccountDetail:writer:key:)
                                                                                 arguments:@[accountId, [accountId identifier], DETAIL_KEY]
                                                                                  protocol:@protocol(IRGetAccountDetail)];

    IRQueryTestCase *getRoles = [[IRQueryTestCase alloc] initWithSelector:@selector(getRoles)
                                                                arguments:nil
                                                                 protocol:@protocol(IRGetRoles)];

    IRQueryTestCase *getRolePermission = [[IRQueryTestCase alloc] initWithSelector:@selector(getRolePermissions:)
                                                                         arguments:@[roleName]
                                                                          protocol:@protocol(IRGetRolePermissions)];

    IRQueryTestCase *getAssetInfo = [[IRQueryTestCase alloc] initWithSelector:@selector(getAssetInfo:)
                                                                    arguments:@[assetId]
                                                                     protocol:@protocol(IRGetAssetInfo)];

    IRQueryTestCase *getPendingTransaction = [[IRQueryTestCase alloc] initWithSelector:@selector(getPendingTransactions)
                                                                             arguments:nil
                                                                              protocol:@protocol(IRGetPendingTransactions)];
    
    IRQueryTestCase *getPeers = [[IRQueryTestCase alloc] initWithSelector:@selector(getPeers)
                                                                arguments:nil
                                                                 protocol:@protocol(IRGetPeers)];

    return @[getAccountTestCase,
             getSignatories,
             getAccountTransactions,
             getAccountAssetTransactions,
             getTransactions,
             getAccountAssets,
             getAccountAssetsPaginated,
             getAccountDetail,
             getAccountDetailPaginated,
             getRoles,
             getRolePermission,
             getAssetInfo,
             getPendingTransaction,
             getPeers];
}

@end
