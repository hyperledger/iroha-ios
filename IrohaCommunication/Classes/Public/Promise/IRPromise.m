#import "IRPromise.h"

@interface IRPromise()

@property(strong, nonatomic)IRPromise* _Nullable next;

@property(strong, nonatomic)IRPromiseResultHandler _Nullable resultHandler;

@property(strong, nonatomic)IRPromiseErrorHandler _Nullable errorHandler;

@property(strong, nonatomic)dispatch_semaphore_t semaphore;

@end

@implementation IRPromise

#pragma mark - Init

- (nonnull instancetype)init {
    if (self = [super init]) {
        _semaphore = dispatch_semaphore_create(1);
    }

    return self;
}

+ (instancetype)promise {
    return [[IRPromise alloc] init];
}

+ (instancetype)promiseWithResult:(nullable id)result {
    IRPromise *promise = [self promise];
    [promise fulfillWithResult:result];

    return promise;
}

#pragma mark - IRPromiseProtocol

- (IRPromise* _Nonnull (^)(IRPromiseResultHandler _Nonnull))onThen {
    return ^(IRPromiseResultHandler block) {
        IRPromise* promise = [[IRPromise alloc] init];

        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);

        self.resultHandler = block;
        self.errorHandler = nil;

        self.next = promise;

        if (self.isFulfilled) {
            [self triggerResultProcessing];
        }

        dispatch_semaphore_signal(self.semaphore);

        return promise;
    };
}

- (IRPromise* _Nonnull (^)(IRPromiseErrorHandler _Nonnull))onError {
    return ^(IRPromiseErrorHandler block) {
        IRPromise* promise = [[IRPromise alloc] init];

        dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);

        self.resultHandler = nil;
        self.errorHandler = block;
        self.next = promise;

        if (self.isFulfilled) {
            [self triggerResultProcessing];
        }

        dispatch_semaphore_signal(self.semaphore);

        return promise;
    };
}

- (void)fulfillWithResult:(id _Nullable)result {
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);

    if (_isFulfilled) {
        return;
    }

    _result = result;
    _isFulfilled = true;

    if (_next) {
        [self triggerResultProcessing];
    }

    dispatch_semaphore_signal(self.semaphore);
}

- (void)triggerResultProcessing {
    if (_isProcessed) {
        return;
    }

    if (![_result isKindOfClass:[NSError class]]) {
        if (_resultHandler) {
            _isProcessed = YES;

            IRPromise* resultPromise = _resultHandler(_result);

            if (!resultPromise) {
                return;
            }

            [resultPromise copyHandlersFromPromise:_next];

            if (resultPromise.isFulfilled) {
                [resultPromise triggerResultProcessing];
            }
        }
    } else {
        if (_errorHandler) {
            _isProcessed = YES;

            IRPromise *resultPromise = _errorHandler(_result);

            if (!resultPromise) {
                return;
            }

            [resultPromise copyHandlersFromPromise:_next];

            if (resultPromise.isFulfilled) {
                [self triggerResultProcessing];
            }

        } else if(_next) {
            _isProcessed = YES;

            [_next fulfillWithResult:_result];
        }
    }
}

- (void)copyHandlersFromPromise:(IRPromise*)promise {
    [self setNext:promise.next];
    [self setResultHandler:promise.resultHandler];
    [self setErrorHandler:promise.errorHandler];
}

@end
