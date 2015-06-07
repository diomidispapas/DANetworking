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

@interface DecideObserver () <DecideDelegate>

@property (nonatomic, strong, nullable) Robot *myRobot;
@property (nonatomic, strong, nullable) NSMutableArray *robots;
@property (nonatomic, strong, nonnull) NSMutableArray *tasks;

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
        _tasks = [NSMutableArray array];
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


#pragma mark - Tasks

- (void)addTask:(RobotTask *)task {
    [_tasks addObject:task];
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
    [self localCapabilityAnalysis];
    [self receiveRemoteNodesCapabilities];
    [self selectionOfLocalContribution];
    [self executionOfControlLoop];
    
}


#pragma mark - DecideDelegate

- (void)localCapabilityAnalysis {
    for (RobotTask *task in _tasks) {
        if (task.meters <= (_myRobot.maxSpeed * 10)) { // with the *10 I assume that the task takes 10 secs. So the robot needs speed (m/s) * secs to cover the meters task.
            
            // Assign the first task to me
            [_myRobot addTask:_tasks[0]];
            
            
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

@end
