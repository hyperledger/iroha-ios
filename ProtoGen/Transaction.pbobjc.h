// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: transaction.proto

// This CPP symbol can be defined to use imports that match up to the framework
// imports needed when using CocoaPods.
#if !defined(GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS)
 #define GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS 0
#endif

#if GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS
 #import <Protobuf/GPBProtocolBuffers.h>
#else
 #import "GPBProtocolBuffers.h"
#endif

#if GOOGLE_PROTOBUF_OBJC_VERSION < 30002
#error This file was generated by a newer version of protoc which is incompatible with your Protocol Buffer library sources.
#endif
#if 30002 < GOOGLE_PROTOBUF_OBJC_MIN_SUPPORTED_VERSION
#error This file was generated by an older version of protoc which is incompatible with your Protocol Buffer library sources.
#endif

// @@protoc_insertion_point(imports)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

CF_EXTERN_C_BEGIN

@class Command;
@class Signature;
@class Transaction_Payload;
@class Transaction_Payload_BatchMeta;
@class Transaction_Payload_ReducedPayload;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Enum Transaction_Payload_BatchMeta_BatchType

typedef GPB_ENUM(Transaction_Payload_BatchMeta_BatchType) {
  /**
   * Value used if any message's field encounters a value that is not defined
   * by this enum. The message will also have C functions to get/set the rawValue
   * of the field.
   **/
  Transaction_Payload_BatchMeta_BatchType_GPBUnrecognizedEnumeratorValue = kGPBUnrecognizedEnumeratorValue,
  Transaction_Payload_BatchMeta_BatchType_Atomic = 0,
  Transaction_Payload_BatchMeta_BatchType_Ordered = 1,
};

GPBEnumDescriptor *Transaction_Payload_BatchMeta_BatchType_EnumDescriptor(void);

/**
 * Checks to see if the given value is defined by the enum or was not known at
 * the time this source was generated.
 **/
BOOL Transaction_Payload_BatchMeta_BatchType_IsValidValue(int32_t value);

#pragma mark - TransactionRoot

/**
 * Exposes the extension registry for this file.
 *
 * The base class provides:
 * @code
 *   + (GPBExtensionRegistry *)extensionRegistry;
 * @endcode
 * which is a @c GPBExtensionRegistry that includes all the extensions defined by
 * this file and all files that it depends on.
 **/
@interface TransactionRoot : GPBRootObject
@end

#pragma mark - Transaction

typedef GPB_ENUM(Transaction_FieldNumber) {
  Transaction_FieldNumber_Payload = 1,
  Transaction_FieldNumber_SignaturesArray = 2,
};

@interface Transaction : GPBMessage

@property(nonatomic, readwrite, strong, null_resettable) Transaction_Payload *payload;
/** Test to see if @c payload has been set. */
@property(nonatomic, readwrite) BOOL hasPayload;

@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<Signature*> *signaturesArray;
/** The number of items in @c signaturesArray without causing the array to be created. */
@property(nonatomic, readonly) NSUInteger signaturesArray_Count;

@end

#pragma mark - Transaction_Payload

typedef GPB_ENUM(Transaction_Payload_FieldNumber) {
  Transaction_Payload_FieldNumber_ReducedPayload = 1,
  Transaction_Payload_FieldNumber_Batch = 5,
};

typedef GPB_ENUM(Transaction_Payload_OptionalBatchMeta_OneOfCase) {
  Transaction_Payload_OptionalBatchMeta_OneOfCase_GPBUnsetOneOfCase = 0,
  Transaction_Payload_OptionalBatchMeta_OneOfCase_Batch = 5,
};

@interface Transaction_Payload : GPBMessage

/** transaction fields */
@property(nonatomic, readwrite, strong, null_resettable) Transaction_Payload_ReducedPayload *reducedPayload;
/** Test to see if @c reducedPayload has been set. */
@property(nonatomic, readwrite) BOOL hasReducedPayload;

/** batch meta fields if tx belong to any batch */
@property(nonatomic, readonly) Transaction_Payload_OptionalBatchMeta_OneOfCase optionalBatchMetaOneOfCase;

@property(nonatomic, readwrite, strong, null_resettable) Transaction_Payload_BatchMeta *batch;

@end

/**
 * Clears whatever value was set for the oneof 'optionalBatchMeta'.
 **/
void Transaction_Payload_ClearOptionalBatchMetaOneOfCase(Transaction_Payload *message);

#pragma mark - Transaction_Payload_BatchMeta

typedef GPB_ENUM(Transaction_Payload_BatchMeta_FieldNumber) {
  Transaction_Payload_BatchMeta_FieldNumber_Type = 1,
  Transaction_Payload_BatchMeta_FieldNumber_ReducedHashesArray = 2,
};

@interface Transaction_Payload_BatchMeta : GPBMessage

@property(nonatomic, readwrite) Transaction_Payload_BatchMeta_BatchType type;

/** array of reduced hashes of all txs from the batch */
@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<NSString *> *reducedHashesArray;
/** The number of items in @c reducedHashesArray without causing the array to be created. */
@property(nonatomic, readonly) NSUInteger reducedHashesArray_Count;

@end

/**
 * Fetches the raw value of a @c Transaction_Payload_BatchMeta's @c type property, even
 * if the value was not defined by the enum at the time the code was generated.
 **/
int32_t Transaction_Payload_BatchMeta_Type_RawValue(Transaction_Payload_BatchMeta *message);
/**
 * Sets the raw value of an @c Transaction_Payload_BatchMeta's @c type property, allowing
 * it to be set to a value that was not defined by the enum at the time the code
 * was generated.
 **/
void SetTransaction_Payload_BatchMeta_Type_RawValue(Transaction_Payload_BatchMeta *message, int32_t value);

#pragma mark - Transaction_Payload_ReducedPayload

typedef GPB_ENUM(Transaction_Payload_ReducedPayload_FieldNumber) {
  Transaction_Payload_ReducedPayload_FieldNumber_CommandsArray = 1,
  Transaction_Payload_ReducedPayload_FieldNumber_CreatorAccountId = 2,
  Transaction_Payload_ReducedPayload_FieldNumber_CreatedTime = 3,
  Transaction_Payload_ReducedPayload_FieldNumber_Quorum = 4,
};

@interface Transaction_Payload_ReducedPayload : GPBMessage

@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray<Command*> *commandsArray;
/** The number of items in @c commandsArray without causing the array to be created. */
@property(nonatomic, readonly) NSUInteger commandsArray_Count;

@property(nonatomic, readwrite, copy, null_resettable) NSString *creatorAccountId;

@property(nonatomic, readwrite) uint64_t createdTime;

@property(nonatomic, readwrite) uint32_t quorum;

@end

NS_ASSUME_NONNULL_END

CF_EXTERN_C_END

#pragma clang diagnostic pop

// @@protoc_insertion_point(global_scope)