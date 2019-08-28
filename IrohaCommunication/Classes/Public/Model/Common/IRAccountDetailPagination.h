/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#import <Foundation/Foundation.h>
#import "IRAccountDetailRecordId.h"


@protocol IRAccountDetailPagination <NSObject>

@property(nonatomic, readonly)UInt32 pageSize;
@property(nonatomic, readonly)id<IRAccountDetailRecordId> nextRecordId;

@end

@protocol IRAccountDetailPaginationFactoryProtocol <NSObject>

+ (nonnull id<IRAccountDetailPagination>)accountDetailPagination:(UInt32)pageSize
                                                    nextRecordId:(nonnull id<IRAccountDetailRecordId>)nextRecordId;

@end

@interface IRAccountDetailPaginationFactory : NSObject <IRAccountDetailPaginationFactoryProtocol>

@end
