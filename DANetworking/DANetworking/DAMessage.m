//
//  DAMessage.m
//  DANetworking
//
//  Created by Diomidis Papas on 27/05/2015.
//  Copyright (c) 2015 Diomidis Papas. All rights reserved.
//

#import "DAMessage.h"

NSString* const kMessageIdKey = @"@MessageId:";
NSString* const kMessageSender = @"@MessageSender:";
NSString* const kMessageType = @"@MessageType:";
NSString* const kMessageBody = @"@MessageBody:";


@interface DAMessage ()

@property (nonatomic, copy, nonnull) NSString *messageId;
@property (nonatomic, copy, nonnull) NSString *sender;
@property (nonatomic, assign) MessageType type;
@property (nonatomic, copy, nonnull) NSString *body;

@end


@implementation DAMessage


#pragma mark - Initialization

- (instancetype)initWithMessageId:(NSString *)messageId
                           sender:(NSString *)sender
                      messageType:(MessageType)type
                             body:(NSString *)body
{
    self = [super init];
    if (self) {
        _messageId = messageId;
        _sender = sender;
        _type = type;
        _body = body;
    }
    return self;
}

- (instancetype)initWithDecodedNSString:(NSString * __nonnull)decodedString {
    NSString *clearIdentifer = [decodedString stringByReplacingOccurrencesOfString:kMessageIdKey withString:@":"];
    NSString *clearIdentifer2 = [clearIdentifer stringByReplacingOccurrencesOfString:kMessageSender withString:@":"];
    NSString *clearIdentifer3 = [clearIdentifer2 stringByReplacingOccurrencesOfString:kMessageType  withString:@":"];
    NSString *clearIdentifer4 = [clearIdentifer3 stringByReplacingOccurrencesOfString:kMessageBody withString:@":"];

    NSArray *tokens = [clearIdentifer4 componentsSeparatedByString:@":"];
    if ([tokens count] == 5) {
        self = [super init];
        if (self) {
            _messageId = [tokens objectAtIndex:1];
            _sender = [tokens objectAtIndex:2];
            _type = [self messageTypeFromNSString:[tokens objectAtIndex:3]];
            _body = [tokens objectAtIndex:4];
        }
    }
    return self;
}


#pragma mark - Encoder

- (NSString *)encodeToNSString {
        NSString *encodedString = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",
                                          kMessageIdKey,
                                          _messageId,
                                          kMessageSender,
                                          _sender,
                                          kMessageType,
                                          [self stringWithMessageEnum:_type],
                                          kMessageBody,
                                          _body];
                                        
                                         return encodedString;
}


#pragma mark - MessageTypeEnum Helper

- (NSString *)stringWithMessageEnum:(MessageType)message {
    NSArray *array = @[
                     @"MessageTypeUnknown",
                     @"MessageTypeJoiningMessage",
                     @"MessageTypeContributionAnalysisMessage",
                     @"MessageTypeStatusUpdateMessage",
                     @"MessageTypeMajorChangeMessage",
                     ];
    return (NSString *)[array objectAtIndex:message];
}

- (MessageType)messageTypeFromNSString:(NSString *)messageTypeInStringFormat {
    NSArray *array = @[
                       @"MessageTypeUnknown",
                       @"MessageTypeJoiningMessage",
                       @"MessageTypeContributionAnalysisMessage",
                       @"MessageTypeStatusUpdateMessage",
                       @"MessageTypeMajorChangeMessage",
                       ];
    
    return ([array indexOfObject:messageTypeInStringFormat]);
}
@end
