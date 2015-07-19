//
//  DecideObserver.h
//  DANetworking
//
//  Created by Diomidis Papas on 27/05/2015.
//  Copyright (c) 2015 Diomidis Papas. All rights reserved.
//

#import "DecideObserverDelegate.h"

@import Foundation;

@class DecideComponent;
@class DAMessage;


/// Closed control loop state machine
typedef NS_ENUM(NSUInteger, ControlLoopState) {
    ControlLoopStateStopped,
    ControlLoopStateLocalCapabilityAnalysis,
    ControlLoopStateWaitingForPeers,
    ControlLoopStatePeerJoined,
    ControlLoopStateContributionReceived,
    ControlLoopStateContributionSelection,
    ControlLoopStateExecution,
    ControlLoopStateExecuting,
};



/// The observer observes the system and handles events
@interface DecideObserver : NSObject

@property (nonatomic, strong, nullable, readonly) DecideComponent *myComponent;
@property (nonatomic, strong, nullable, readonly) NSMutableArray *components;
@property (nonatomic, assign, readonly) ControlLoopState controlLoopState;
@property (nonatomic, assign, readonly, getter = isControlLoopRunning) BOOL controlLoopRunning;
@property (nonatomic, weak, nonnull) id<DecideObserverDelegate> delegate;

/// Singleton
+ (nullable instancetype)sharedInstance;


#pragma mark - Robots

- (void)setMyComponent:(DecideComponent * __nonnull)component;

- (void)addPeer:(DecideComponent * __nonnull)component;


#pragma mark - Decide Actions

- (void)start;

@end
