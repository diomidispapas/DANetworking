//
//  Robot.h
//  DANetworking
//
//  Created by Diomidis Papas on 27/05/2015.
//  Copyright (c) 2015 Diomidis Papas. All rights reserved.
//

@import Foundation;

#import "DecideComponent.h"

@class RobotTask;

@interface Robot : DecideComponent

@property (nonatomic, strong, nonnull, readonly) NSString *name;
@property (nonatomic, strong, nonnull, readonly) NSMutableArray *globalTasks;
@property (nonatomic, strong, nonnull, readonly) NSMutableArray *localContributioPossibleCombinations;
@property (nonatomic, strong, nullable, readonly) RobotTask *localTask;
@property (nonatomic, assign, readonly) double maxSpeed;
@property (nonatomic, assign, readonly) double powerConsumtionPerSec;



#pragma mark - Initialization

- (nullable instancetype)initWithName:(NSString *__nonnull)name
                    maxSpeed:(double)maxSpeed
       powerConsumtionPerSec:(double)powerConsumtionPerSec;


- (nullable instancetype)initWithName:(NSString * __nonnull)name
                    maxSpeed:(double)maxSpeed
       powerConsumtionPerSec:(double)powerConsumtionPerSec
                 globalTasks:(NSMutableArray * __nonnull)globalTasks;


#pragma mark - Setters

- (void)addGlobalTask:(RobotTask * __nonnull)task;

- (void)setLocalTask:(RobotTask * __nonnull)task;

- (void)addLocalContributioPossibleCombinationsObject:(RobotTask * __nonnull)task;

- (void)setLocalContributioPossibleCombinations:(NSArray * __nonnull)combinations;

@end
