//
//  DecideObserver.m
//  DANetworking
//
//  Created by Diomidis Papas on 27/05/2015.
//  Copyright (c) 2015 Diomidis Papas. All rights reserved.
//

#import "DecideObserver.h"
#import "Robot.h"

#import "DAMessage.h"
#import "DANetwork.h"

@interface DecideObserver ()

@property (nonatomic, strong, nullable) Robot *myRobot;
@property (nonatomic, strong, nullable) NSMutableArray *robots;

@end

@implementation DecideObserver

+ (instancetype)sharedInstance {
    static DecideObserver *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[DecideObserver alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _robots = [NSMutableArray array];
    }
    return self;
}

- (void)setMyRobot:( Robot * __nonnull )robot {
    _myRobot = robot;
}

- (void)addPeer:( Robot * __nonnull )robot {
    [_robots addObject:robot];
}

- (void)sendDummyMessageToPeers {
    DAMessage *message = [[DAMessage alloc] initWithMessageId:@"DummyMessage" sender:self.myRobot.name messageType:MessageTypeUnknown body:@"Hello guys"];
    [self sendMessageToPeers:message];
}

#pragma mark - Private methods

- (void)sendMessageToPeers:(DAMessage * __nonnull)message {
    [[DANetwork sharedInstance] sendMessage:message completionBlock:^(BOOL success, NSError * __nullable error) {
        if (error) {
            
        }
        
        if (success) {
            
        }
        
    }];
}



@end
