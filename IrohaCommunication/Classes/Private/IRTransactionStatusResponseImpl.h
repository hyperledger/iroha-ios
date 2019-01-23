/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

#import <Foundation/Foundation.h>
#import "IRTransactionStatusResponse.h"

@interface IRTransactionStatusResponse : NSObject<IRTransactionStatusResponse>

- (nonnull instancetype)initWithStatus:(IRTransactionStatus)status
                       transactionHash:(nonnull NSData*)transactionHash
                           description:(nullable NSString*)statusDescription;

@end
