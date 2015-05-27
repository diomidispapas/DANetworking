//
//  DAMessage.m
//  DANetworking
//
//  Created by Diomidis Papas on 27/05/2015.
//  Copyright (c) 2015 Diomidis Papas. All rights reserved.
//

#import "DAMessage.h"

@interface DAMessage ()

@property (nonatomic, strong, nonnull) NSString *messageId;
@property (nonatomic, strong, nonnull) NSString *sender;
@property (nonatomic, assign) MessageType type;
@property (nonatomic, strong, nonnull) NSString *body;

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
@end
