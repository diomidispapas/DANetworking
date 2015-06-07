//
//  Robot.m
//  DANetworking
//
//  Created by Diomidis Papas on 27/05/2015.
//  Copyright (c) 2015 Diomidis Papas. All rights reserved.
//

#import "Robot.h"

@interface Robot ()

@property (nonatomic, strong, nonnull) NSString *name;
@property (nonatomic, strong, nonnull) NSMutableArray *tasks;
@property (nonatomic, strong, nonnull) NSMutableArray *localTasks;
@property (nonatomic, assign) double maxSpeed;

@end

@implementation Robot


#pragma mark - Initialization

- (instancetype)initWithName:(NSString *)name
                       maxSpeed:(double)maxSpeed {
    self = [super init];
    if (self) {
        _name = name;
        _maxSpeed = maxSpeed;
        _tasks = [NSMutableArray array];
    }
    return self;
}

- (instancetype)initWithName:(NSString *)name
                    maxSpeed:(double)maxSpeed
                       tasks:(NSMutableArray *)tasks {
    if (self = [self initWithName:name maxSpeed:maxSpeed]) {
        _tasks = tasks;
    }
    return self;
}



#pragma mark - Robot Functionality 

- (void)addTask:(RobotTask *)task {
    [_tasks addObject:task];
}



- (void)statusCheck {
    return;
}

- (void)notifyPeers {
    
}

- (void)receivePeerCapabilitySummary {
    
}

@end
