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
@property (nonatomic, strong, nonnull) NSMutableArray *localContributioPossibleCombinations;
@property (nonatomic, strong, nullable) id localTask;
@property (nonatomic, strong, nullable) DecideTask *globalTask;

@end


@implementation DecideComponent


#pragma mark - Initialization

- (instancetype)initWithIdentifier:(NSString *)identifier {
    self = [super init];
    if (self) {
        _identifier = identifier;
        
        // Array intialization
        _localContributioPossibleCombinations = [NSMutableArray array];
    }
    return self = [super init];
}


#pragma mark - Setters

- (void)setGlobalTask:(DecideTask *)task {
    _globalTask = task;
}

- (void)setLocalTask:(id )task {
    _localTask = task;
}

- (void)addLocalContributioPossibleCombinationsObject:(DecideTask *)task {
    [_localContributioPossibleCombinations addObject:task];
}

- (void)setLocalContributioPossibleCombinations:(NSMutableArray *)combinations {
    _localContributioPossibleCombinations = combinations;
}

@end
