#import <Foundation/Foundation.h>

@interface NSDate (IrohaCommunication)

- (UInt64)milliseconds;

+ (nonnull instancetype)dateWithTimestampInMilliseconds:(UInt64)milliseconds;

@end
