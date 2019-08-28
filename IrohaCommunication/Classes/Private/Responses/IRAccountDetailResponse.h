/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#import <Foundation/Foundation.h>
#import "IRQueryResponse.h"
#import "IRAccountDetailRecordId.h"

@interface IRAccountDetailResponse : NSObject<IRAccountDetailResponse>

- (nonnull instancetype)initWithDetail:(nonnull NSString*)detail
                            totalCount:(UInt64)totalCount
                          nextRecordId:(nullable id<IRAccountDetailRecordId>)nextRecordId
                             queryHash:(nonnull NSData*)queryHash;

@end
