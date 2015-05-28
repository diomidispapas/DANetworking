//
//  Robot.h
//  DANetworking
//
//  Created by Diomidis Papas on 27/05/2015.
//  Copyright (c) 2015 Diomidis Papas. All rights reserved.
//

@import Foundation;

@interface Robot : NSObject

@property (nonatomic, strong, nonnull, readonly) NSString *name;
@property (nonatomic, strong, nonnull, readonly) NSMutableArray *tasks;
@property (nonatomic, strong, nonnull, readonly) NSMutableArray *localTasks;

- (nullable instancetype)initWithName:(NSString * __nonnull)name
                       speed:(double)speed;

- (nullable instancetype)initWithName:(NSString * __nonnull)name
                       speed:(double)speed
                       tasks:(NSMutableArray * __nonnull)tasks;
@end
