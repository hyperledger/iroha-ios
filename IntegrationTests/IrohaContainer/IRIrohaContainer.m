#import "IRIrohaContainer.h"

static NSString* const DOCKER_HOST = @"http://localhost:49721";
static NSString* const CONTAINER = @"649f761b58de";

static NSString * IROHA_IP = @"127.0.0.1";
static NSString * IROHA_PORT = @"50051";

static NSUInteger CONNECTION_TRIES = 10;
static NSTimeInterval CONNECTION_TRY_DELAY = 1.0;

@interface IRIrohaContainer()

@property(strong, nonatomic)NSURLSession *session;
@property(strong, nonatomic)IRNetworkService *irohaService;

@end

@implementation IRIrohaContainer

#pragma mark - Initialization

- (instancetype)init {
    if (self = [super init]) {
        _session = [NSURLSession sessionWithConfiguration:NSURLSessionConfiguration.defaultSessionConfiguration];

        id<IRAddress> irohaAddress = [IRAddressFactory addressWithIp:IROHA_IP
                                                                port:IROHA_PORT
                                                               error:nil];

        _iroha = [[IRNetworkService alloc] initWithAddress:irohaAddress];

        NSString *queueName = @"co.jp.soramitsu.irohacontainertest.queue";
        dispatch_queue_t responseQueue = dispatch_queue_create((char*)[queueName cStringUsingEncoding:NSUTF8StringEncoding],
                                                               DISPATCH_QUEUE_SERIAL);
        _iroha.responseSerialQueue = responseQueue;
    }

    return self;
}

+ (nonnull instancetype)shared {
    static dispatch_once_t onceToken;
    static IRIrohaContainer *sharedContainer;

    dispatch_once(&onceToken, ^{
        sharedContainer = [[IRIrohaContainer alloc] init];
    });

    return sharedContainer;
}

#pragma mark - Interface

- (nullable NSError*)start {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

    __block NSError *resultError;

    NSURLRequest *restartRequest = [self createContainerRestartRequest];
    NSURLSessionDataTask *restartTask = [_session dataTaskWithRequest:restartRequest
                                                    completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                        resultError = [self handleRestartResponse:response
                                                                                             data:data
                                                                                    receivedError:error];
                                                        dispatch_semaphore_signal(semaphore);
                                                    }];

    [restartTask resume];

    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

    if (resultError) {
        return resultError;
    }

    __block NSString *taskId;
    NSURLRequest *taskCreationRequest = [self createIrohaDaemonTaskPreparationRequest];
    NSURLSessionDataTask *daemonTaskCreationTask = [_session dataTaskWithRequest:taskCreationRequest
                                                               completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                                   taskId = [self handleTaskPreparationResponse:response
                                                                                                       data:data
                                                                                                  receivedError:error
                                                                                                    resultError:&resultError];
                                                                   dispatch_semaphore_signal(semaphore);
                                                               }];

    [daemonTaskCreationTask resume];

    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

    if (resultError) {
        return resultError;
    }

    NSURLRequest *taskExecutionRequest = [self createIrohaDaemonTaskStartRequest:taskId];
    NSURLSessionDataTask *daemonTaskExecutionTask = [_session dataTaskWithRequest:taskExecutionRequest
                                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                                    resultError = [self handleTaskExecutionResponse:response
                                                                                                               data:data
                                                                                                      receivedError:error];

                                                                    dispatch_semaphore_signal(semaphore);
                                                                }];

    [daemonTaskExecutionTask resume];

    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

    if (resultError) {
        return resultError;
    }

    BOOL connected = NO;

    for(NSUInteger tryIndex = 0; tryIndex < CONNECTION_TRIES; tryIndex++) {
        connected = [self checkConnectivity];

        if (connected) {
            break;
        }

        sleep(CONNECTION_TRY_DELAY);
    }

    if (!connected) {
        resultError = [IRIrohaContainer errorForMessage:@"Couldn't establish socket connection"];
    }

    return resultError;
}

- (nullable NSError*)stop {
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

    __block NSError *resultError;
    NSURLRequest *stopRequest = [self createContainerStopRequest];
    NSURLSessionDataTask *stopTask = [_session dataTaskWithRequest:stopRequest
                                                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                     resultError = [self handleStopResponse:response
                                                                                       data:data
                                                                              receivedError:error];
                                                     dispatch_semaphore_signal(semaphore);
                                                 }];

    [stopTask resume];

    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

    return resultError;
}

#pragma mark - Requests

- (nonnull NSURLRequest*)createContainerRestartRequest {
    NSURL *url = [NSURL URLWithString:DOCKER_HOST];
    NSString *path = [NSString stringWithFormat:@"containers/%@/restart", CONTAINER];
    url = [url URLByAppendingPathComponent:path];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];

    return request;
}

- (nonnull NSURLRequest*)createIrohaDaemonTaskPreparationRequest {
    NSURL *url = [NSURL URLWithString:DOCKER_HOST];
    NSString *path = [NSString stringWithFormat:@"containers/%@/exec", CONTAINER];
    url = [url URLByAppendingPathComponent:path];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];

    NSString *bodyString = @"{\"AttachStdin\": false, \"AttachStdout\": false, \"AttachStderr\": false, \"Tty\":false,\
    \"Cmd\": [\"bash\", \"-c\", \"(irohad --config config.docker --genesis_block genesis.block --keypair_name node0 --overwrite_ledger) &\"]}";

    [request setHTTPBody:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
    [request setAllHTTPHeaderFields:@{@"Content-Type": @"application/json"}];

    return request;
}

- (nonnull NSURLRequest*)createIrohaDaemonTaskStartRequest:(NSString *)taskId {
    NSURL *url = [NSURL URLWithString:DOCKER_HOST];
    NSString *path = [NSString stringWithFormat:@"exec/%@/start", taskId];
    url = [url URLByAppendingPathComponent:path];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];

    NSString *bodyString = @"{\"Detach\": false, \"Tty\": false}";

    [request setHTTPBody:[bodyString dataUsingEncoding:NSUTF8StringEncoding]];
    [request setAllHTTPHeaderFields:@{@"Content-Type": @"application/json"}];

    return request;
}

- (nonnull NSURLRequest*)createContainerStopRequest {
    NSURL *url = [NSURL URLWithString:DOCKER_HOST];
    NSString *path = [NSString stringWithFormat:@"containers/%@/stop", CONTAINER];
    url = [url URLByAppendingPathComponent:path];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];

    return request;
}

#pragma mark - Response

- (nullable NSError*)handleRestartResponse:(nonnull NSURLResponse *)response
                                      data:(nullable NSData *)data
                             receivedError:(nullable NSError *)receivedError {
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        NSUInteger statusCode = [(NSHTTPURLResponse*)response statusCode];

        switch (statusCode) {
            case 204:
                return nil;
                break;
            case 404:
                return [IRIrohaContainer errorForMessage:@"Container not found during restart"];
                break;
            case 500:
                return [IRIrohaContainer errorForMessage:@"Internal server error during restart"];
                break;
            default:
                return [IRIrohaContainer errorForMessage:@"Unexpected status code during restart"];
                break;
        }
    }

    if (receivedError) {
        return receivedError;
    }

    return [IRIrohaContainer errorForMessage:@"Unexpected response received during restart"];
}

- (nullable NSString*)handleTaskPreparationResponse:(nonnull NSURLResponse *)response
                                           data:(nullable NSData *)data
                                      receivedError:(nullable NSError *)receivedError
                                        resultError:(NSError*_Nullable*_Nullable)resultError {
    if (data) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data
                                                               options:0
                                                                 error:resultError];

        NSString *taskId = [result objectForKey:@"Id"];
        if (!taskId && resultError) {
            if (!*resultError) {
                *resultError = [IRIrohaContainer errorForMessage:@"No task id found"];
            }
        }

        return taskId;
    } else if (receivedError) {
        if (resultError) {
            *resultError = receivedError;
        }
        return nil;
    } else {
        if (resultError) {
            *resultError = [IRIrohaContainer errorForMessage:@"Daemon preparation task failed."];
        }
        return nil;
    }
}

- (nullable NSError*)handleTaskExecutionResponse:(nonnull NSURLResponse *)response
                                            data:(nullable NSData *)data
                                   receivedError:(nullable NSError *)receivedError {
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        NSUInteger statusCode = [(NSHTTPURLResponse*)response statusCode];

        switch (statusCode) {
                case 200:
                return nil;
                break;
                case 404:
                return [IRIrohaContainer errorForMessage:@"Iroha container not found on try to run iroha daemon"];
                break;
                case 409:
                return [IRIrohaContainer errorForMessage:@"Container is stoped or paused on try to run iroha daemon"];
                break;
            default:
                return [IRIrohaContainer errorForMessage:@"Unexpected status code on try to run iroha daemon"];
                break;
        }
    }

    if (receivedError) {
        return receivedError;
    }

    return [IRIrohaContainer errorForMessage:@"Unexpected response received on try to run iroha daemon"];
}

- (nullable NSError*)handleStopResponse:(nonnull NSURLResponse *)response
                                   data:(nullable NSData *)data
                          receivedError:(nullable NSError *)receivedError {
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        NSUInteger statusCode = [(NSHTTPURLResponse*)response statusCode];

        switch (statusCode) {
                case 204: case 304:
                return nil;
                break;
                case 404:
                return [IRIrohaContainer errorForMessage:@"Iroha container not found on try to stop"];
                break;
                case 500:
                return [IRIrohaContainer errorForMessage:@"Internal server error on try to stop"];
                break;
            default:
                return [IRIrohaContainer errorForMessage:@"Unexpected status code on try to stop"];
                break;
        }
    }

    if (receivedError) {
        return receivedError;
    }

    return [IRIrohaContainer errorForMessage:@"Unexpected response received on try to stop"];
}

#pragma mark - Iroha

- (BOOL)checkConnectivity {
    NSData *transactionHash = [[NSUUID UUID].UUIDString dataUsingEncoding:NSUTF8StringEncoding];

    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

    __block BOOL connected = NO;

    [_iroha fetchTransactionStatus:transactionHash].onThen(^IRPromise * _Nullable(id result) {
        connected = [result conformsToProtocol:@protocol(IRTransactionStatusResponse)];

        dispatch_semaphore_signal(semaphore);

        return nil;
    }).onError(^IRPromise * _Nullable(NSError* error) {
        dispatch_semaphore_signal(semaphore);

        return nil;
    });

    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

    return connected;
}

#pragma mark - Helper

+ (nonnull NSError *)errorForMessage:(nonnull NSString*)message {
    NSString *domain = [NSString stringWithFormat:@"co.jp.soramitsu.iroha.%@", NSStringFromClass([IRIrohaContainer class])];
    return [NSError errorWithDomain:domain
                               code:0
                           userInfo:@{NSLocalizedDescriptionKey: message}];
}

@end
