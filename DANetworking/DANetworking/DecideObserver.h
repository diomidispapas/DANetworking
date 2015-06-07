//
//  DecideObserver.h
//  DANetworking
//
//  Created by Diomidis Papas on 27/05/2015.
//  Copyright (c) 2015 Diomidis Papas. All rights reserved.
//

@import Foundation;

@class Robot;
@class RobotTask;
@class DAMessage;

@interface DecideObserver : NSObject

@property (nonatomic, strong, nullable, readonly) Robot *myRobot;
@property (nonatomic, strong, nullable, readonly) NSMutableArray *robots;
@property (nonatomic, strong, nonnull, readonly) NSMutableArray *tasks;

+ (nullable instancetype)sharedInstance;


#pragma mark - Robots

- (void)setMyRobot:(Robot * __nonnull)robot;
- (void)addPeer:(Robot * __nonnull)robot;


#pragma mark - Tasks

- (void)addTask:(RobotTask * __nonnull)task;


#pragma mark - Decide Actions

- (void)sendDummyMessageToPeers;
- (void)offlineStart;

@end
