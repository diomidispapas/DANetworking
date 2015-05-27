//
//  DANetwork.m
//  DANetworking
//
//  Created by Diomidis Papas on 27/05/2015.
//  Copyright (c) 2015 Diomidis Papas. All rights reserved.
//

#import "DANetwork.h"
#import "DANetworking-Swift.h" //Import Swift files

#import "DAMessage.h"

@interface DANetwork () <PubNubHelperDelegate>
@property (nonatomic, strong, nullable) PNChannel *channel;
@property (nonatomic, strong, nullable) NSString *userIdentifier;
@property (nonatomic, strong, nullable) NSMutableArray *participants;
@end

@implementation DANetwork


#pragma mark - Initialization

+ (instancetype)sharedInstance {
    static DANetwork *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[DANetwork alloc] init];
    });

    return _sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)subscribeUser:(NSString *)userIdentifier
    toChannelWithName:(NSString *)channelName
      completionBlock:(void(^)(BOOL success, NSError *error))completion {
    
    self.userIdentifier = userIdentifier;
    
    switch (_serviceType) {
        case ServiceTypePubNubService: {
            
            self.channel = [PNChannel channelWithName:channelName shouldObservePresence:YES];
            NSArray *channels = [NSArray arrayWithObject:self.channel];
            
            [[PubNubHelper sharedInstance] subscribe:channels competionHandler:^(BOOL success, PNError * __nullable error) {
                if (success) {
                    [PubNubHelper sharedInstance].delegate = self;
                    completion(YES, nil);
                } else {
                    completion(NO, [NSError errorWithDomain:error.domain code:error.code userInfo:nil]);
                }
            }];
            break;
        }
            
        case ServiceTypeMatrixService: {
            break;
        }
    }
}

#pragma mark - Networking Actions

- (void)sendMessage:(DAMessage *)message
    completionBlock:(void(^)(BOOL success, NSError *error))completion {
    
    switch (_serviceType) {
        case ServiceTypePubNubService: {
            [[PubNubHelper sharedInstance] sendMessage:message.body channel:self.channel completionHandler:^(BOOL success, PNError *error) {
                if (success) {
                    completion(YES, nil);
                }
                else {
                    completion(NO, nil);
                }
            }];
            break;
        }
          
        case ServiceTypeMatrixService: {
            break;
        }
    }
}


#pragma mark - <PubNubHelperDelegate>

- (void)didReceiveMessage:(PNMessage *)message {
    DAMessage *da_message = [[DAMessage alloc] initWithMessageId:@"Unknown_message_id" sender:@"Unknown_sender" messageType:MessageTypeUnknown body:message.message];
    [self.delegate didReceiveMessage:da_message];
}

- (void)didReceiveJoinEvent {
    [self.delegate didReceiveJoinEvent];
}

@end