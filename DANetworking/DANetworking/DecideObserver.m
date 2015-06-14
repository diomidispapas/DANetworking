//
//  DecideObserver.m
//  DANetworking
//
//  Created by Diomidis Papas on 27/05/2015.
//  Copyright (c) 2015 Diomidis Papas. All rights reserved.
//

#import "DecideObserver.h"
#import "DecideDelegate.h"
#import "DecideObserver+NetworkSend.h"

#import "Robot.h"
#import "RobotTask.h"

#import "DAMessage.h"
#import "DANetwork.h"

@interface DecideObserver () <DecideDelegate, DANetworkDelegate>

@property (nonatomic, strong, nullable) Robot *myRobot;
@property (nonatomic, strong, nullable) NSMutableArray *robots;
@property (nonatomic, assign) ControlLoopState controlLoopState;

@property (nonatomic, assign, getter = isControlLoopRunning) BOOL controlLoopRunning;
@property (nonatomic, assign, getter = islocalCapabilityAnalysisReady) BOOL localCapabilityAnalysisReady;


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
        
        [DANetwork sharedInstance].delegate = self;
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


#pragma mark - Decide Actions

- (void)start {
    
    // If the control loop has not started
    if (![self isControlLoopRunning]) {
        
        // Update the flag (getter = isControlLoopRunning)
        self.controlLoopRunning = YES;
        
        // Start the closed control loop on a different thread
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

            [self closedControlLoop];

        });

    }
    
}


#pragma mark - Decide Control Loop

- (void)closedControlLoop {
    while ([self isControlLoopRunning]) {

        switch (_controlLoopState) {
            case ControlLoopStateStopped:
                _controlLoopState = ControlLoopStateLocalCapabilityAnalysis;
                break;
            case ControlLoopStateLocalCapabilityAnalysis: {
                _localCapabilityAnalysisReady = NO;
                [self localCapabilityAnalysis];
                break;
            }
            case ControlLoopStateWaitingForPeers: {
                #ifdef DEBUG
                    NSLog(@"Waiting for peers");
                #endif
                break;
            }
            case ControlLoopStatePeerJoined: {
                // Whenever someone joins the room send my capability analysis
                [self sendLocalCapabilityAnalysisToPeers];
                break;
            }
            case ControlLoopStateContributionReceived: {
                if (self.localCapabilityAnalysisReady) {
                    _controlLoopState = ControlLoopStateContributionSelection;
                    //[self receiveRemoteNodesCapabilities];
                    
                }
                /*
                else {
                    _controlLoopState = ControlLoopStateLocalCapabilityAnalysis;
                }
                 */
                break;
            }
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
    
    /// For each speed until we reach our mac speed calculate the possible combination.
    
    for (double i = 0; i <= _myRobot.maxSpeed; i++) {
        
        // Create a possible task
        RobotTask *possibleTask = [[RobotTask alloc] initWithMeters:i time:1 powerConsumtion:(_myRobot.powerConsumtionPerSec * i)];
        
        // Add the combination to the possible combinations
        
        [_myRobot addLocalContributioPossibleCombinationsObject:possibleTask];
        
        #ifdef DEBUG
            NSLog(@"Possible task: %ldm, %lds, %ldJ" ,(long)possibleTask.meters, (long)possibleTask.time, ((long)possibleTask.powerConsumtion * (long)possibleTask.meters));
        #endif
    }
    
    [self sendLocalCapabilityAnalysisToPeers];
    
}

- (void)sendLocalCapabilityAnalysisToPeers {
    [self sendCLAMessageToPeersWithBody:_myRobot.localContributioPossibleCombinations];
    
    _localCapabilityAnalysisReady = YES;
    if (_robots.count == 0) {
        _controlLoopState = ControlLoopStateWaitingForPeers;
    } else {
        _controlLoopState = ControlLoopStateContributionSelection;
    }


}

/**
 * The capability summary is shared with the peer components
 */
- (void)receiveRemoteNodesCapabilities {
    
    dispatch_async( dispatch_get_main_queue(), ^{
    #ifdef DEBUG
            NSLog(@"DECIDE: Received peer's capabilities");
    #endif
    });
   
}

/**
 * This stage is executed infrequently (e.g., when the component joins the system)
 */
- (void)selectionOfLocalContribution {
    
    dispatch_async( dispatch_get_main_queue(), ^{
    #ifdef DEBUG
        NSLog(@"DECIDE: Selection of local contribution");
    #endif
    });

}

/**
 * Most of the time, the execution of a local control loop is the only DECIDE stage carried out by a component.
 */
- (void)executionOfControlLoop {
    dispatch_async( dispatch_get_main_queue(), ^{
    #ifdef DEBUG
        NSLog(@"DECIDE: Execution of control loop");
    #endif
    });
    
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
    
    _controlLoopState = ControlLoopStatePeerJoined;
    
    [_delegate didReceiveJoinEvent:message];
}

- (void)didReceiveContributionAnalysisMessageEvent:(DAMessage * __nonnull)message {
    #ifdef DEBUG
        NSString *labelText = [NSString stringWithFormat:@"LCA Received from other node"];
        NSLog(@"%@", labelText);
    #endif
    
    
    if (![_robots containsObject:message.sender]) {
        [_robots addObject:message.sender];
        _controlLoopState = ControlLoopStateContributionReceived;
        [_delegate didReceiveContributionAnalysisMessageEvent:message];
    }
    
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
