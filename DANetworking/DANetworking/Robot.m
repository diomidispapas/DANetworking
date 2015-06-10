//
//  Robot.m
//  DANetworking
//
//  Created by Diomidis Papas on 27/05/2015.
//  Copyright (c) 2015 Diomidis Papas. All rights reserved.
//

#import "Robot.h"
#import "RobotTask.h"

@interface Robot ()

@property (nonatomic, strong, nonnull) NSString *name;
@property (nonatomic, strong, nonnull) NSMutableArray *globalTasks;
@property (nonatomic, strong, nullable) RobotTask *localTask;
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
        _globalTasks = [NSMutableArray array];
    }
    return self;
}

- (instancetype)initWithName:(NSString *)name
                    maxSpeed:(double)maxSpeed
                 globalTasks:(NSMutableArray *)globalTasks {
    
    if (self = [self initWithName:name maxSpeed:maxSpeed]) {
        _globalTasks = globalTasks;
    }
    return self;
}



#pragma mark - Robot Tasks Functionallity

- (void)addGlobalTask:(RobotTask *)task {
    [_globalTasks addObject:task];
}

- (void)setLocalTask:(RobotTask *)task {
    _localTask = task;
}



- (void)statusCheck {
    return;
}

- (void)notifyPeers {
    
}

- (void)receivePeerCapabilitySummary {
    
}

@end
