//
//  Robot.m
//  DANetworking
//
//  Created by Diomidis Papas on 27/05/2015.
//  Copyright (c) 2015 Diomidis Papas. All rights reserved.
//

#import "Robot.h"
#import "DANetworking-Swift.h"

@interface Robot () <DecideProtocol>

@property (nonatomic, strong, nonnull) NSString *name;
@property (nonatomic, strong, nonnull) NSMutableArray *tasks;
@property (nonatomic, strong, nonnull) NSMutableArray *localTasks;

@property (nonatomic, assign) double speed;

@end

@implementation Robot


#pragma mark - Initialization

- (instancetype)initWithName:(NSString *)name
                       speed:(double)speed
{
    self = [super init];
    if (self) {
        _name = name;
        _speed = speed;
        _tasks = [NSMutableArray array];
    }
    return self;
}

- (instancetype)initWithName:(NSString *)name
                       speed:(double)speed
                       tasks:(NSMutableArray *)tasks
{
    self = [super init];
    if (self) {
        _name = name;
        _speed = speed;
        _tasks = tasks;
    }
    return self;
}



#pragma mark - Robot Functionality 

- (void)statusCheck {
    return;
}

- (void)notifyPeers {
    
}

- (void)receivePeerCapabilitySummary {
    
}

#pragma mark - <DecideProtocol>

- (void)localCapabilityAnalysis {
    
}

- (void)receiveRemoteNodesCapabilities {
    
}

- (void)selectionOfLocalContribution {
    
}

- (void)executionOfControlLoop {
    
}

- (void)majorChange {
    
}


@end
