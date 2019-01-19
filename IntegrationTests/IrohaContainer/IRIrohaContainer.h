#import <Foundation/Foundation.h>
@import IrohaCommunication;

@interface IRIrohaContainer : NSObject

+ (nonnull instancetype)shared;

@property(nonatomic, readonly)IRNetworkService * _Nonnull iroha;

- (nullable NSError*)start;
- (nullable NSError*)stop;

@end
