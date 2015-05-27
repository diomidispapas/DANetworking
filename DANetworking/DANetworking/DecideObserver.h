//
//  DecideObserver.h
//  DANetworking
//
//  Created by Diomidis Papas on 27/05/2015.
//  Copyright (c) 2015 Diomidis Papas. All rights reserved.
//

@import Foundation;
@class Robot;
@class DAMessage;

@interface DecideObserver : NSObject

@property (nonatomic, strong, nullable, readonly) Robot *myRobot;
@property (nonatomic, strong, nullable, readonly) NSMutableArray *robots;

+ (instancetype)sharedInstance;
- (void)setMyRobot:( Robot * __nonnull )robot;
- (void)addPeer:( Robot * __nonnull )robot;

- (void)sendDummyMessageToPeers;

@end
