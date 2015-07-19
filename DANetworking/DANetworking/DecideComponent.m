//
//  DecideComponent.m
//  DANetworking
//
//  Created by Diomidis Papas on 04/07/2015.
//  Copyright (c) 2015 Diomidis Papas. All rights reserved.
//

#import "DecideComponent.h"
#import "DecideTask.h"

@interface DecideComponent ()

@property (nonatomic, strong, nonnull) NSString *identifier;
@property (nonatomic, strong, nonnull) NSMutableArray *globalTasks;
@property (nonatomic, strong, nonnull) NSMutableArray *localContributioPossibleCombinations;
@property (nonatomic, strong, nullable) DecideTask *localTask;

@end


@implementation DecideComponent


#pragma mark - Initialization

- (instancetype)initWithIdentifier:(NSString *)identifier {
    self = [super init];
    if (self) {
        _identifier = identifier;
        
        // Array intialization
        _globalTasks = [NSMutableArray array];
        _localContributioPossibleCombinations = [NSMutableArray array];
    }
    return self = [super init];
}


#pragma mark - Setters

- (void)addGlobalTask:(DecideTask *)task {
    [_globalTasks addObject:task];
}

- (void)setLocalTask:(DecideTask *)task {
    _localTask = task;
}

- (void)addLocalContributioPossibleCombinationsObject:(DecideTask *)task {
    [_localContributioPossibleCombinations addObject:task];
}

- (void)setLocalContributioPossibleCombinations:(NSMutableArray *)combinations {
    _localContributioPossibleCombinations = combinations;
}

@end
