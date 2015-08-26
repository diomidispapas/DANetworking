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

@interface DAMessage : NSObject <NSCoding>

@property (nonatomic, copy, nonnull, readonly) NSString *messageId;
@property (nonatomic, copy, nonnull, readonly) NSString *sender;
@property (nonatomic, assign, readonly) MessageType type;
@property (nonatomic, copy, nonnull, readonly) NSString* body;
@property (nonatomic, copy, nonnull) NSArray *lcaBody;


- (nullable instancetype)initWithMessageId:(NSString * __nonnull)messageId
                                    sender:(NSString * __nonnull)sender
                               messageType:(MessageType)type
                                      body:(NSString *  __nonnull)body;

- (NSString * __nonnull)archivedMessageToData:(DAMessage * __nonnull)message;

- (nullable instancetype)convertDataToMessageObject:(NSString * __nonnull)dataString;

@end
