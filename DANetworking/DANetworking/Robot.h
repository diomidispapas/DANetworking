//
//  Robot.h
//  DANetworking
//
//  Created by Diomidis Papas on 27/05/2015.
//  Copyright (c) 2015 Diomidis Papas. All rights reserved.
//

@import Foundation;

@class RobotTask;

@interface Robot : NSObject

@property (nonatomic, strong, nonnull, readonly) NSString *name;
@property (nonatomic, strong, nonnull, readonly) NSMutableArray *tasks;
@property (nonatomic, strong, nonnull, readonly) NSMutableArray *localTasks;
@property (nonatomic, assign, readonly) double maxSpeed;


- (nullable instancetype)initWithName:(NSString * __nonnull)name
                             maxSpeed:(double)maxSpeed;

- (nullable instancetype)initWithName:(NSString * __nonnull)name
                             maxSpeed:(double)maxSpeed
                                tasks:(NSMutableArray * __nonnull)tasks;

- (void)addTask:(RobotTask *)task;

@end
