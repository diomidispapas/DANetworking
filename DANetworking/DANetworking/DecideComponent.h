//
//  DecideComponent.h
//  DANetworking
//
//  Created by Diomidis Papas on 04/07/2015.
//  Copyright (c) 2015 Diomidis Papas. All rights reserved.
//

@import Foundation;

@class DecideTask;

@interface DecideComponent : NSObject

@property (nonatomic, strong, nonnull, readonly) NSString *identifier;
@property (nonatomic, strong, nonnull, readonly) NSMutableArray *localContributioPossibleCombinations;
@property (nonatomic, strong, nullable, readonly) id localTask;
@property (nonatomic, strong, nullable, readonly) DecideTask *globalTask;

- (nullable instancetype)initWithIdentifier:(NSString * __nonnull)identifier;

#pragma mark - Setters

- (void)setGlobalTask:(DecideTask * __nonnull)task;

- (void)setLocalTask:(id __nonnull)task;

- (void)addLocalContributioPossibleCombinationsObject:(DecideTask * __nonnull)task;

- (void)setLocalContributioPossibleCombinations:(NSMutableArray * __nonnull)combinations;

@end
