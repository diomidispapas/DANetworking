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

@property (nonatomic, strong, nullable) DecideComponent *myComponent;
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
#pragma mark - Components

- (void)setMyComponent:(DecideComponent * __nonnull )component {
    _myComponent = component;
}

- (void)addPeer:(DecideComponent * __nonnull )component {
    [_components addObject:component];
}


#pragma mark - DECIDE Actions

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
                
                _controlLoopState = ControlLoopStateExecuting;
                break;
            }
            case ControlLoopStateExecuting: {
                //[_delegate didChangeDecideStatus:@"Excecuting"];
                break;
            }
        }
    }
}


#pragma mark - DecideDelegate

- (void)localCapabilityAnalysis {
    _myComponent.localContributioPossibleCombinations = [[_delegate localCapabilitiesAnalysisCalculation] mutableCopy];
}

- (void)sendLocalCapabilityAnalysisToPeers {
    [self sendCLAMessageToPeersWithBody:_myComponent.localContributioPossibleCombinations];
}

/// The capability summary is shared with the peer components
- (void)receiveRemoteNodesCapabilities {
    dispatch_async( dispatch_get_main_queue(), ^{
        #ifdef DEBUG
            NSLog(@"DECIDE: Received peer's capabilities");
        #endif
    });
   
}

/// This stage is executed infrequently (e.g., when the component joins the system)
- (void)selectionOfLocalContribution {
    dispatch_async( dispatch_get_main_queue(), ^{
        #ifdef DEBUG
            NSLog(@"DECIDE: Selection of local contribution");
        #endif
        [_delegate calculatePossibleCombinations];
    });
}

/// Most of the time, the execution of a local control loop is the only DECIDE stage carried out by a component.
- (void)executionOfControlLoop {
    dispatch_async( dispatch_get_main_queue(), ^{
        #ifdef DEBUG
            NSLog(@"DECIDE: Execution of control loop");
        #endif
        [_delegate execution];
    });
}

/// Infrequently, events such as signifi- cant workload increases or failures of component parts render a DECIDE local control loop unable to achieve its CLA.
- (void)majorChange {
    
}



#pragma mark - DANetworkDelegate

//Unused
- (void)didReceiveMessage:(DAMessage * __nonnull)message {
    #ifdef DEBUG
        NSString *labelText = [NSString stringWithFormat:@"Message received from: %@ with body: %@",message.sender , message.body];
        NSLog(@"%@", labelText);
    #endif
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
        NSLog(@"LCA Received from other node");
    #endif
    
    // Check if I have already received a capability analysis from this node
    if (![_components containsObject:message.sender]) {
        for (DecideComponent *component in _components) {
            if ([component.identifier isEqualToString:message.sender]) {
                
                // If have the same values
                if ([self isEqual:message.lcaBody and:component.localContributioPossibleCombinations]) {
                    
                    return;
                } else {
                    return;
                }
            }
        }
    }
    
    
    if (![_components containsObject:message.sender]) {
        
        // Invoke the delegate.
        DecideComponent *component = [_delegate didReceiveContributionAnalysisMessageEvent:message];

        // Create a new robot instance (Peer).
        //Robot *peer = [[Robot alloc] initWithName:message.sender maxSpeed:0 powerConsumtionPerSec:0 globalTasks:_myRobot.globalTasks];
       
        [component setLocalContributioPossibleCombinations:message.lcaBody];
        
        
        // In case that I already have LCA from the same component
        NSMutableArray *discardedItems = [NSMutableArray array];
        for (DecideComponent *alreadyKnownComponent in _components) {
            if ([alreadyKnownComponent.identifier isEqualToString:component.identifier]) {
                [discardedItems addObject:component];
            }
        }
        [_components removeObjectsInArray:discardedItems];

        // Add it to my list.
        [_components addObject:component];
        
        // Change the the state.
        _controlLoopState = ControlLoopStateContributionReceived;
        
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

- (BOOL)isEqual:(NSArray*)array1 and:(NSArray*)array2 {
    NSCountedSet *set1 = [NSCountedSet setWithArray:array1];
    NSCountedSet *set2 = [NSCountedSet setWithArray:array2];
    return [set1 isEqualToSet:set2];
}

@end
