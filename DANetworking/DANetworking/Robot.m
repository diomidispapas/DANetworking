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
@property (nonatomic, strong, nonnull) NSMutableArray *localContributioPossibleCombinations;
@property (nonatomic, strong, nullable) RobotTask *localTask;
@property (nonatomic, assign) double maxSpeed;
@property (nonatomic, assign) double powerConsumtionPerSec;


@end

@implementation Robot


#pragma mark - Initialization

- (instancetype)initWithName:(NSString *)name
                    maxSpeed:(double)maxSpeed
       powerConsumtionPerSec:(double)powerConsumtionPerSec {
    self = [super init];
    if (self) {
        _name = name;
        _maxSpeed = maxSpeed;
        _powerConsumtionPerSec = powerConsumtionPerSec;
        
        // Array intialization
        _globalTasks = [NSMutableArray array];
        _localContributioPossibleCombinations = [NSMutableArray array];
    }
    return self;
}

- (instancetype)initWithName:(NSString *)name
                    maxSpeed:(double)maxSpeed
       powerConsumtionPerSec:(double)powerConsumtionPerSec
                 globalTasks:(NSMutableArray *)globalTasks {
    
    if (self = [self initWithName:name maxSpeed:maxSpeed powerConsumtionPerSec:powerConsumtionPerSec]) {
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

- (void)addLocalContributioPossibleCombinationsObject:(RobotTask *)task {
    [_localContributioPossibleCombinations addObject:task];
}

- (void)setLocalContributioPossibleCombinations:(NSArray *)combinations {
    _localContributioPossibleCombinations = [combinations mutableCopy];
}



- (void)statusCheck {
    return;
}

- (void)notifyPeers {
    
}

- (void)receivePeerCapabilitySummary {
    
}

@end
