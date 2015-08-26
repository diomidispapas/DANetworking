//
//  DANetwork.m
//  DANetworking
//
//  Created by Diomidis Papas on 27/05/2015.
//  Copyright (c) 2015 Diomidis Papas. All rights reserved.
//

#import "DANetwork.h"
#import "DANetworking-Swift.h" //Import Swift files

#import "DANetwork+Messages.h"

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

- (instancetype)init {
    self = [super init];
    if (self) {
        self.participants = [NSMutableArray array];
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
                    
                    // Send message joining message to others
                    // Join event went together with the LCA
                    
                    /*
                    [self sendJoiningMessageWithCompletionBlock:^(BOOL sucess, NSError *error) {
                        if (success) {
                        #ifdef DEBUG
                            NSLog(@"DANetwrok: Joining message sent from user %@", _userIdentifier);
                        #endif
                        completion(YES, nil);
                        }
                    }];
                    */
                    
                    
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
           
            NSString *encodedMessage = [message archivedMessageToData:message];
            
            [[PubNubHelper sharedInstance] sendMessage:encodedMessage channel:self.channel completionHandler:^(BOOL success, PNError *error) {
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
    DAMessage *da_message = [DAMessage alloc];
    da_message = [da_message convertDataToMessageObject:message.message];

    if (![da_message.sender isEqualToString:self.userIdentifier]) {
        switch (da_message.type) {
            case MessageTypeUnknown:
                [self.delegate didReceiveMessage:da_message];
                break;
            case MessageTypeJoiningMessage:
                [self.delegate didReceiveJoinEvent:da_message];
                break;
            case MessageTypeContributionAnalysisMessage:
                [self.delegate didReceiveContributionAnalysisMessageEvent:da_message];
                break;
            case MessageTypeStatusUpdateMessage:
                break;
            case MessageTypeMajorChangeMessage:
                break;
           }
    }
}

@end
