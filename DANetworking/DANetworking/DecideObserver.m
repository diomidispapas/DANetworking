//
//  DecideObserver.m
//  DANetworking
//
//  Created by Diomidis Papas on 27/05/2015.
//  Copyright (c) 2015 Diomidis Papas. All rights reserved.
//

#import "DecideObserver.h"
#import "DecideDelegate.h"

#import "Robot.h"
#import "RobotTask.h"

#import "DAMessage.h"
#import "DANetwork.h"

@interface DecideObserver () <DecideDelegate, DANetworkDelegate>

@property (nonatomic, strong, nullable) Robot *myRobot;
@property (nonatomic, strong, nullable) NSMutableArray *robots;
@property (nonatomic, assign) ControlLoopState controlLoopState;
@property (nonatomic, assign, getter = isControlLoopRunning) BOOL controlLoopRunning;

@end

@implementation DecideObserver


#pragma mark - Initialization

+ (instancetype)sharedInstance {
    static DecideObserver *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[DecideObserver alloc] init];
    });
    return _sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _robots = [NSMutableArray array];
        _controlLoopRunning = NO;
        _controlLoopRunning = ControlLoopStateStopped;
    }
    return self;
}


#pragma mark - Public
#pragma mark - Robots

- (void)setMyRobot:( Robot * __nonnull )robot {
    _myRobot = robot;
}

- (void)addPeer:( Robot * __nonnull )robot {
    [_robots addObject:robot];
}



#pragma mark - Networking

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


#pragma mark - Decide Actions

- (void)offlineStart {
    
    // If the control loop has not started
    if (![self isControlLoopRunning]) {
        
        // Update the flag (getter = isControlLoopRunning)
        self.controlLoopRunning = YES;
        
        // Start the closed control loop
        [self closedControlLoop];
    }
    
}

- (void)closedControlLoop {
    while ([self isControlLoopRunning]) {

        switch (_controlLoopState) {
            case ControlLoopStateStopped:
                _controlLoopState = ControlLoopStateLocalCapabilityAnalysis;
                break;
            case ControlLoopStateLocalCapabilityAnalysis:
                [self localCapabilityAnalysis];
                break;
            case ControlLoopStateContributionReceived:
                [self receiveRemoteNodesCapabilities];
                break;
            case ControlLoopStateContributionSelection:
                [self selectionOfLocalContribution];
                break;
            case ControlLoopStateExecution:
                [self executionOfControlLoop];
                break;
        }
    }
}


#pragma mark - DecideDelegate

- (void)localCapabilityAnalysis {
    for (RobotTask *task in _myRobot.globalTasks) {
        if (task.meters <= (_myRobot.maxSpeed * 10)) { // with the *10 I assume that the task takes 10 secs. So the robot needs speed (m/s) * secs to cover the meters task.
            
            // Assign the first task to me
            [_myRobot setLocalTask:task];
            
            
            #ifdef DEBUG
                NSLog(@"DECIDE: My task is task with meters %ld" ,(long)task.meters);
            #endif
            continue;
        }
    }
}

/**
 * The capability summary is shared with the peer components
 */
- (void)receiveRemoteNodesCapabilities {
    
    #ifdef DEBUG
        NSLog(@"DECIDE: Received peer's capabilities");
    #endif
}

/**
 * This stage is executed infrequently (e.g., when the component joins the system)
 */
- (void)selectionOfLocalContribution {
    #ifdef DEBUG
        NSLog(@"DECIDE: Selection of local contribution");
    #endif
}

/**
 * Most of the time, the execution of a local control loop is the only DECIDE stage carried out by a component.
 */
- (void)executionOfControlLoop {
    #ifdef DEBUG
        NSLog(@"DECIDE: Execution of control loop");
    #endif
}

/**
 * Infrequently, events such as signifi- cant workload increases or failures of component parts render a DECIDE local control loop unable to achieve its CLA.
 */
- (void)majorChange {
    
}



#pragma mark - DANetworkDelegate

- (void)didReceiveMessage:(DAMessage * __nonnull)message {
    #ifdef DEBUG
        NSString *labelText = [NSString stringWithFormat:@"Message received from: %@ with body: %@",message.sender , message.body];
        NSLog(@"%@", labelText);
    #endif
    [_delegate didReceiveMessage:message];
}

- (void)didReceiveJoinEvent:(DAMessage * __nonnull)message {
    #ifdef DEBUG
        NSString *labelText = [NSString stringWithFormat:@"Someone joined your channel"];
        NSLog(@"%@", labelText);
    #endif
    [_delegate didReceiveJoinEvent:message];
}

- (void)didReceiveContributionAnalysisMessageEvent:(DAMessage * __nonnull)message {
    #ifdef DEBUG
        NSString *labelText = [NSString stringWithFormat:@"LCA Received from other node"];
        NSLog(@"%@", labelText);
    #endif
    [_delegate didReceiveContributionAnalysisMessageEvent:message];
}

- (void)didReceiveStatusUpdatesMessageEvent:(DAMessage * __nonnull)message {
    #ifdef DEBUG
        NSString *labelText = [NSString stringWithFormat:@"Status update received"];
        NSLog(@"%@", labelText);
    #endif
    [_delegate didReceiveStatusUpdatesMessageEvent:message];
}

- (void)didReceiveMajorChangeMessageEvent:(DAMessage * __nonnull)message {
    #ifdef DEBUG
        NSString *labelText = [NSString stringWithFormat:@"Major event message received"];
        NSLog(@"%@", labelText);
    #endif
    [_delegate didReceiveMajorChangeMessageEvent:message];
}

@end
