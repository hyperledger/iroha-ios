/**
 * Copyright Soramitsu Co., Ltd. All Rights Reserved.
 * SPDX-License-Identifier: Apache-2.0
 */

@import XCTest;
@import IrohaCommunication;

@interface IRPromiseTests : XCTestCase

@end

@implementation IRPromiseTests

- (void)testSequenceSuccessivePromiseResults {
    IRPromise *promise = [IRPromise promise];

    NSUInteger firstIntResult = 10;
    NSString *secondStringResult = @"10";

    XCTestExpectation *expectation = [[XCTestExpectation alloc] init];
    [expectation setAssertForOverFulfill:true];
    [expectation setExpectedFulfillmentCount:2];

    promise.onThen(^IRPromise*(id result) {
        XCTAssertEqualObjects(@(firstIntResult), result);

        IRPromise *promise = [IRPromise promise];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [promise fulfillWithResult:secondStringResult];
        });

        [expectation fulfill];

        return promise;
    }).onThen(^IRPromise*(id result) {
        XCTAssertEqualObjects(result, secondStringResult);

        IRPromise *promise = [IRPromise promise];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [promise fulfillWithResult:nil];
        });

        [expectation fulfill];

        return promise;
    }).onError(^IRPromise*(NSError *error) {
        XCTFail();

        return nil;
    });

    [promise fulfillWithResult:@(firstIntResult)];

    [self waitForExpectations:@[expectation] timeout:10];
}

- (void)testWithErrorFullfiled {
    IRPromise *promise = [IRPromise promise];
    IRPromise *currentPromise = promise;

    NSUInteger errorIndex = 5;

    XCTestExpectation *expectation = [[XCTestExpectation alloc] init];
    [expectation setExpectedFulfillmentCount:errorIndex + 2];
    [expectation setAssertForOverFulfill:YES];

    for(NSUInteger i = 0; i < 10; i++) {
        currentPromise = currentPromise.onThen(^IRPromise*(id result){
            XCTAssertEqualObjects(@(i), result);

            IRPromise *promise = [IRPromise promise];

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (i != errorIndex) {
                    [promise fulfillWithResult:@(i + 1)];
                } else {
                    [promise fulfillWithResult:[NSError errorWithDomain:@"TestDomain"
                                                                   code:-100
                                                               userInfo:nil]];
                }
            });

            if (i > errorIndex) {
                XCTFail();
            }

            [expectation fulfill];

            return promise;
        });
    }

    currentPromise.onError(^IRPromise*(NSError * error) {
        [expectation fulfill];

        return nil;
    });

    [promise fulfillWithResult:@0];

    [self waitForExpectations:@[expectation] timeout:10];
}

- (void)testFirstFullfillWithError {
    XCTestExpectation *expectation = [[XCTestExpectation alloc] init];

    NSError *error = [NSError errorWithDomain:@"Test domain"
                                         code:0
                                     userInfo:nil];

    [IRPromise promiseWithResult:error].onThen(^IRPromise*(id result){
        XCTFail();

        return [IRPromise promiseWithResult:@(0)];
    }).onThen(^IRPromise*(id result) {
        XCTFail();

        return nil;
    }).onError(^IRPromise*(NSError *error) {
        [expectation fulfill];

        return nil;
    });

    [self waitForExpectations:@[expectation] timeout:10.0];
}

- (void)testHandleImmediateResultReturnedFromError {
    XCTestExpectation *expectation = [[XCTestExpectation alloc] init];

    NSError *error = [NSError errorWithDomain:@"Test domain"
                                         code:0
                                     userInfo:nil];

    NSString *initialResult = @"Initial result";
    NSString *expectedResult = @"Expected result";

    [IRPromise promiseWithResult:initialResult].onThen(^IRPromise*(id result){
        return [IRPromise promiseWithResult:error];
    }).onThen(^IRPromise*(id result) {
        XCTFail();

        return nil;
    }).onError(^IRPromise*(NSError *error) {
        return [IRPromise promiseWithResult:expectedResult];
    }).onThen(^IRPromise*(id result) {
        XCTAssertEqualObjects(result, expectedResult);

        [expectation fulfill];

        return nil;
    });

    [self waitForExpectations:@[expectation] timeout:10.0];
}

- (void)testHandleAsyncResultReturnedFromErrorAndThenReturnError {
    XCTestExpectation *expectation = [[XCTestExpectation alloc] init];

    NSError *error = [NSError errorWithDomain:@"Test domain"
                                         code:0
                                     userInfo:nil];

    NSString *initialResult = @"Initial result";
    NSString *expectedResult = @"Expected result";

    IRPromise *asyncPromise = [IRPromise promise];

    asyncPromise.onThen(^IRPromise*(id result){
        return [IRPromise promiseWithResult:error];
    }).onThen(^IRPromise*(id result) {
        XCTFail();

        return nil;
    }).onError(^IRPromise*(NSError *error) {
        return [IRPromise promiseWithResult:expectedResult];
    }).onThen(^IRPromise*(id result) {
        XCTAssertEqualObjects(result, expectedResult);

        [expectation fulfill];

        return nil;
    });

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [asyncPromise fulfillWithResult:initialResult];
    });

    [self waitForExpectations:@[expectation] timeout:10.0];
}

@end
