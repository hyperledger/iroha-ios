@import XCTest;
@import IrohaCommunication;

static const NSUInteger VALID_ADDRESSES_COUNT = 4;
static NSString* const VALID_IPV4[] = {
    @"255.255.255.255",
    @"192.168.0.1",
    @"3.222.2.250",
    @"1.1.1.1"
};

static const NSUInteger INVALID_ADDRESSES_COUNT = 5;
static NSString* const INVALID_IPV4[] = {
    @"",
    @"255.255.255",
    @"00.168.0.1",
    @"3.222.2.250.255",
    @"1.1111.1.1"
};

static NSString* const VALID_PORT = @"8080";

static const NSUInteger INVALID_PORTS_COUNT = 4;
static NSString* const INVALID_PORTS[] = {
    @"",
    @"65356666",
    @"68678",
    @"70__"
};

static const NSUInteger VALID_ADDRESS_DOMAINS_COUNT = 5;
static NSString * const VALID_ADDRESS_DOMAINS[] = {
    @"g",
    @"gmail.com",
    @"g1mail.com",
    @"g1-mail.com.g1-mail.com.g1mail.com.g1mail.com.g1-mail.com",
    @"g1mailg1mailg1mailg1mailg1mailg1mailg1mailg1mailg1mailg1mailL.com"
};

static const NSUInteger INVALID_ADDRESS_DOMAINS_COUNT = 5;
static NSString * const INVALID_ADDRESS_DOMAINS[] = {
    @"",
    @"1gmail.com",
    @"g_mail.com",
    @"gmail.",
    @"g1mailg1mailg1mailg1mailg1mailg1mailg1mailg1mailg1mailg1mailLg1mail.com"
};

@interface IRAddressTests : XCTestCase

@end

@implementation IRAddressTests

- (void)testValidAddress {
    for (NSUInteger i = 0; i < VALID_ADDRESSES_COUNT; i++) {
        id<IRAddress> address = [IRAddressFactory addressWithIp:VALID_IPV4[i]
                                                           port:VALID_PORT
                                                          error:nil];
        XCTAssertNotNil(address);

        NSString *expectedAddress = [NSString stringWithFormat:@"%@:%@", VALID_IPV4[i], VALID_PORT];
        XCTAssertEqualObjects(address.value, expectedAddress);
    }
}

- (void)testInvalidAddressWithError {
    for (NSUInteger i = 0; i < INVALID_ADDRESSES_COUNT; i++) {
        NSError *error;
        id<IRAddress> address = [IRAddressFactory addressWithIp:INVALID_IPV4[i]
                                                           port:VALID_PORT
                                                          error:&error];
        XCTAssertNil(address);
        XCTAssertNotNil(error);
        XCTAssertEqual(error.code, IRInvalidAddressIp);
    }
}

- (void)testInvalidAddressWithoutError {
    for (NSUInteger i = 0; i < INVALID_ADDRESSES_COUNT; i++) {
        id<IRAddress> address = [IRAddressFactory addressWithIp:INVALID_IPV4[i]
                                                           port:VALID_PORT
                                                          error:nil];
        XCTAssertNil(address);
    }
}

- (void)testInvalidIpPortWithError {
    for (NSUInteger i = 0; i < INVALID_PORTS_COUNT; i++) {
        NSError *error;
        id<IRAddress> address = [IRAddressFactory addressWithIp:VALID_IPV4[0]
                                                           port:INVALID_PORTS[i]
                                                          error:&error];
        XCTAssertNil(address);
        XCTAssertNotNil(error);
        XCTAssertEqual(error.code, IRInvalidAddressPort);
    }
}

- (void)testInvalidIpPortWithoutError {
    for (NSUInteger i = 0; i < INVALID_PORTS_COUNT; i++) {
        id<IRAddress> address = [IRAddressFactory addressWithIp:VALID_IPV4[0]
                                                           port:INVALID_PORTS[i]
                                                          error:nil];
        XCTAssertNil(address);
    }
}

- (void)testValidDomain {
    for (NSUInteger i = 0; i < VALID_ADDRESS_DOMAINS_COUNT; i++) {
        id<IRAddress> address = [IRAddressFactory addressWithDomain:VALID_ADDRESS_DOMAINS[i]
                                                               port:VALID_PORT
                                                              error:nil];

        NSString *expectedAddress = [NSString stringWithFormat:@"%@:%@", VALID_ADDRESS_DOMAINS[i], VALID_PORT];

        XCTAssertNotNil(address);
        XCTAssertEqualObjects(address.value, expectedAddress);
    }
}

- (void)testInvalidDomainWithError {
    for (NSUInteger i = 0; i < INVALID_ADDRESS_DOMAINS_COUNT; i++) {
        NSError *error;
        id<IRAddress> address = [IRAddressFactory addressWithDomain:INVALID_ADDRESS_DOMAINS[i]
                                                               port:VALID_PORT
                                                              error:&error];

        XCTAssertNil(address);
        XCTAssertNotNil(error);
        XCTAssertEqual(error.code, IRInvalidAddressDomain);
    }
}

- (void)testInvalidDomainWithoutError {
    for (NSUInteger i = 0; i < INVALID_ADDRESS_DOMAINS_COUNT; i++) {
        id<IRAddress> address = [IRAddressFactory addressWithDomain:INVALID_ADDRESS_DOMAINS[i]
                                                               port:VALID_PORT
                                                              error:nil];

        XCTAssertNil(address);
    }
}

- (void)testInvalidDomainPortWithError {
    for (NSUInteger i = 0; i < INVALID_PORTS_COUNT; i++) {
        NSError *error;
        id<IRAddress> address = [IRAddressFactory addressWithDomain:VALID_ADDRESS_DOMAINS[0]
                                                               port:INVALID_PORTS[i]
                                                              error:&error];
        XCTAssertNil(address);
        XCTAssertNotNil(error);
        XCTAssertEqual(error.code, IRInvalidAddressPort);
    }
}

- (void)testInvalidDomainPortWithoutError {
    for (NSUInteger i = 0; i < INVALID_PORTS_COUNT; i++) {
        id<IRAddress> address = [IRAddressFactory addressWithDomain:VALID_ADDRESS_DOMAINS[0]
                                                               port:INVALID_PORTS[i]
                                                              error:nil];
        XCTAssertNil(address);
    }
}

@end
