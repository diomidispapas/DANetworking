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
@property (nonatomic, strong, nullable) NSMutableArray *components;
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
        _components = [NSMutableArray array];
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
    [_components addObject:robot];
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
            case ControlLoopStateStopped: {
                // [_delegate didChangeDecideStatus:@"Stopped"];

                _controlLoopState = ControlLoopStateLocalCapabilityAnalysis;
                
                break;
            }
            case ControlLoopStateLocalCapabilityAnalysis: {
                // [_delegate didChangeDecideStatus:@"Local Capability Analysis"];

                _localCapabilityAnalysisReady = NO;
                
                [self localCapabilityAnalysis];
                
                [self sendLocalCapabilityAnalysisToPeers];
                
                _localCapabilityAnalysisReady = YES;

                if (_components.count == 0) {
                    _controlLoopState = ControlLoopStateWaitingForPeers;
                } else {
                    _controlLoopState = ControlLoopStateContributionSelection;
                }
                break;
            }
            case ControlLoopStateWaitingForPeers: {
                // [_delegate didChangeDecideStatus:@"Waiting for peers"];
                break;
            }
            //DEPRECATED
            case ControlLoopStatePeerJoined: {
                // [_delegate didChangeDecideStatus:@"Someone joined"];

                // Whenever someone joins the room send my capability analysis
                [self sendLocalCapabilityAnalysisToPeers];
                
                _localCapabilityAnalysisReady = YES;
                if (_components.count == 0) {
                    _controlLoopState = ControlLoopStateContributionReceived;
                } else {
                    _controlLoopState = ControlLoopStateContributionSelection;
                }

                break;
            }
            case ControlLoopStateContributionReceived: {
                // [_delegate didChangeDecideStatus:@"Received Local Capability Analysis"];
                
                
                if (self.localCapabilityAnalysisReady) {
                    
                    // Whenever someone joins the room send my capability analysis
                    [self sendLocalCapabilityAnalysisToPeers];
                    
                    _controlLoopState = ControlLoopStateContributionSelection;
                    [self receiveRemoteNodesCapabilities];
                }
                else {
                    _controlLoopState = ControlLoopStateLocalCapabilityAnalysis;
                }
                
                break;
            }
            case ControlLoopStateContributionSelection: {
                // [_delegate didChangeDecideStatus:@"Contribution Selection"];

                [self selectionOfLocalContribution];
                _controlLoopState = ControlLoopStateExecution;
                break;
            }
            case ControlLoopStateExecution: {
                //[_delegate didChangeDecideStatus:@"Excecution"];

                [self executionOfControlLoop];
                break;
            }
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
            NSLog(@"LCA task: %ldm, %lds, %ldJ" ,(long)possibleTask.meters, (long)possibleTask.time, ((long)possibleTask.powerConsumtion * (long)possibleTask.meters));
        #endif
    }
    
    
}

- (void)sendLocalCapabilityAnalysisToPeers {
    [self sendCLAMessageToPeersWithBody:_myRobot.localContributioPossibleCombinations];
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
        
        NSMutableArray *combinations = [NSMutableArray array];
        
        for (RobotTask *myCandidateCombinationTask in _myRobot.localContributioPossibleCombinations) {
            for (Robot *peer in _components) {
                for (RobotTask *peersCandidateCombinationTask in peer.localContributioPossibleCombinations) {
                    
                    NSArray *aCombination = [NSArray arrayWithObjects:myCandidateCombinationTask, peersCandidateCombinationTask, nil];
                    
                    [combinations addObject:aCombination];
                }
            }
        }
        
        NSLog(@"Final Combinations");
        int numberOfCombinations = 0;
        for (NSArray *combination in combinations) {
            numberOfCombinations++;
            NSLog(@"Combination %d",numberOfCombinations);

            for (RobotTask *task in combination) {
                NSLog(@"Possible task: %ldm, %lds, %ldJ" ,(long)task.meters, (long)task.time, ((long)task.powerConsumtion * (long)task.meters));

            }
        }
        NSLog(@"Number of possible combinations %d", numberOfCombinations);

    });

}

/**
 * Most of the time, the execution of a local control loop is the only DECIDE stage carried out by a component.
 */
- (void)executionOfControlLoop {
    /*
    dispatch_async( dispatch_get_main_queue(), ^{
    #ifdef DEBUG
        NSLog(@"DECIDE: Execution of control loop");
    #endif
    });
     */
    //NSLog(@"DECIDE: Execution of control loop");

}

/**
 * Infrequently, events such as signifi- cant workload increases or failures of component parts render a DECIDE local control loop unable to achieve its CLA.
 */
- (void)majorChange {
    
}



#pragma mark - DANetworkDelegate

//Unused
- (void)didReceiveMessage:(DAMessage * __nonnull)message {
    #ifdef DEBUG
        NSString *labelText = [NSString stringWithFormat:@"Message received from: %@ with body: %@",message.sender , message.body];
        NSLog(@"%@", labelText);
    #endif
    [_delegate didReceiveMessage:message];
}

//Deprecated
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
    
    // Check if I have already received a capability analysis from this node
    if (![_components containsObject:message.sender]) {
        for (Robot *robot in _components) {
            if ([robot.name isEqualToString:message.sender]) {
                
                // If have the same values
                if ([self isEqual:message.lcaBody and:_myRobot.localContributioPossibleCombinations]) {
                    
                    return;
                }
            }
        }
    }
    
    
    if (![_components containsObject:message.sender]) {
        // Create a new robot instance (Peer).
        Robot *peer = [[Robot alloc] initWithName:message.sender maxSpeed:0 powerConsumtionPerSec:0 globalTasks:_myRobot.globalTasks];
        [peer setLocalContributioPossibleCombinations:message.lcaBody];
        
        // In case that I already have LCA from the same component

        NSMutableArray *discardedItems = [NSMutableArray array];
        for (Robot *robot in _components) {
            if ([robot.name isEqualToString:peer.name]) {
                [discardedItems addObject:robot];
            }
        }
        [_components removeObjectsInArray:discardedItems];

        // Add it to my list.
        [_components addObject:peer];
        
        // Change the the state.
        _controlLoopState = ControlLoopStateContributionReceived;
        
        // Invoke the delegate.
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

#pragma mark - Helper

- (BOOL)isEqual:(NSArray*)array1 and:(NSArray*)array2
{
    NSCountedSet *set1 = [NSCountedSet setWithArray:array1];
    NSCountedSet *set2 = [NSCountedSet setWithArray:array2];
    return [set1 isEqualToSet:set2];
}

@end
