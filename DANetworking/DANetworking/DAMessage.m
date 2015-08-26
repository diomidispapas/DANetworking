//
//  DAMessage.m
//  DANetworking
//
//  Created by Diomidis Papas on 27/05/2015.
//  Copyright (c) 2015 Diomidis Papas. All rights reserved.
//

#import "DAMessage.h"


static NSString* const kMessageIdKey = @"MessageId";
static NSString* const kMessageSender = @"MessageSender";
static NSString* const kMessageType = @"MessageType";
static NSString* const kMessageBody = @"MessageBody";
static NSString* const kMessageLCABody = @"MessageLCABody";


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
        self.messageId = messageId;
        self.sender = sender;
        self.type = type;
        self.body = body;
        
        self.lcaBody = [NSArray array];
    }
    return self;
}

- (NSString *)archivedMessageToData:(DAMessage *)message {
    
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:message];
    
    NSString *base64Encoded = [data base64EncodedStringWithOptions:0];
    
    return base64Encoded;
    
}

- (instancetype)convertDataToMessageObject:(NSString *)dataString {
    
    NSData *data = [[NSData alloc] initWithBase64EncodedString:dataString options:0];
    
    @try {
        DAMessage *message = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        return message;

    }  @catch (NSException * exception) {
        NSLog(@"NSException: %@", exception);
    }
    return nil;
}


#pragma mark - <NSCoding>

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.messageId forKey:kMessageIdKey];
    [aCoder encodeObject:self.sender forKey:kMessageSender];
    [aCoder encodeInteger:self.type forKey:kMessageType];
    [aCoder encodeConditionalObject:self.body forKey:kMessageBody];
    
    [aCoder encodeObject:self.lcaBody forKey:kMessageLCABody];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    if (self) {
        self.messageId = [aDecoder decodeObjectForKey:kMessageIdKey];
        self.sender = [aDecoder decodeObjectForKey:kMessageSender];
        self.type = [aDecoder decodeIntegerForKey:kMessageType];
        self.body = [aDecoder decodeObjectForKey:kMessageBody];
        
        self.lcaBody = [aDecoder decodeObjectForKey:kMessageLCABody];
    }
    return self;
}

@end
