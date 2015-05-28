//
//  DAMessage.h
//  DANetworking
//
//  Created by Diomidis Papas on 27/05/2015.
//  Copyright (c) 2015 Diomidis Papas. All rights reserved.
//

@import Foundation;

typedef NS_ENUM(NSUInteger, MessageType) {
    MessageTypeUnknown,
    MessageTypeJoiningMessage,
    MessageTypeContributionAnalysisMessage,
    MessageTypeStatusUpdateMessage,
    MessageTypeMajorChangeMessage,
};

@interface DAMessage : NSObject

@property (nonatomic, strong, nonnull, readonly) NSString *messageId;
@property (nonatomic, strong, nonnull, readonly) NSString *sender;
@property (nonatomic, assign, readonly) MessageType type;
@property (nonatomic, strong, nonnull, readonly) NSString *body;

- (nullable instancetype)initWithMessageId:(NSString * __nonnull)messageId
                           sender:(NSString * __nonnull)sender
                      messageType:(MessageType)type
                             body:(NSString * __nonnull)body;

- (nullable instancetype)initWithDecodedNSString:(NSString * __nonnull)decodedString;
- (NSString * __nonnull)encodeToNSString;

@end
