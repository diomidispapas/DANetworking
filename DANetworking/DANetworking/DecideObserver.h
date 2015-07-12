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


typedef NS_ENUM(NSUInteger, ControlLoopState) {
    ControlLoopStateStopped,
    ControlLoopStateLocalCapabilityAnalysis,
    ControlLoopStateWaitingForPeers,
    ControlLoopStatePeerJoined,
    ControlLoopStateContributionReceived,
    ControlLoopStateContributionSelection,
    ControlLoopStateExecution,
};


@protocol DecideObserverDelegate <NSObject>

- (void)didChangeDecideStatus:(NSString * __nonnull)status;
- (void)didReceiveMessage:(DAMessage * __nonnull)message;
- (void)didReceiveJoinEvent:(DAMessage * __nonnull)message;
- (void)didReceiveContributionAnalysisMessageEvent:(DAMessage * __nonnull)message;
- (void)didReceiveStatusUpdatesMessageEvent:(DAMessage * __nonnull)message;
- (void)didReceiveMajorChangeMessageEvent:(DAMessage * __nonnull)message;

@end

/**
 *  The observer observes the system and handles events
 */
@interface DecideObserver : NSObject

@property (nonatomic, strong, nullable, readonly) Robot *myRobot;
@property (nonatomic, strong, nullable, readonly) NSMutableArray *components;
@property (nonatomic, assign, readonly) ControlLoopState controlLoopState;
@property (nonatomic, assign, readonly, getter = isControlLoopRunning) BOOL controlLoopRunning;
@property (nonatomic, weak, nonnull) id<DecideObserverDelegate> delegate;

+ (nullable instancetype)sharedInstance;


#pragma mark - Robots

- (void)setMyRobot:(Robot * __nonnull)robot;

- (void)addPeer:(Robot * __nonnull)robot;


#pragma mark - Decide Actions

- (void)start;

@end
