//
//  Robot.m
//  DANetworking
//
//  Created by Diomidis Papas on 27/05/2015.
//  Copyright (c) 2015 Diomidis Papas. All rights reserved.
//

#import "Robot.h"
#import "RobotTask.h"

#import "DecideComponent.h"

@interface Robot ()

@property (nonatomic, strong, nonnull) NSString *name;
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
    }
    return self;
}
/*
- (instancetype)initWithName:(NSString *)name
                    maxSpeed:(double)maxSpeed
       powerConsumtionPerSec:(double)powerConsumtionPerSec
                 globalTasks:(NSMutableArray *)globalTasks {
    
    if (self = [self initWithName:name maxSpeed:maxSpeed powerConsumtionPerSec:powerConsumtionPerSec]) {
        super.globalTasks = globalTasks;
    }
    return self;
}
*/

@end
