//
//  PrimesTask.m
//  DANetworking
//
//  Created by Diomidis Papas on 19/07/2015.
//  Copyright (c) 2015 Diomidis Papas. All rights reserved.
//

#import "PrimesTask.h"

static NSString* const kPrimesTaskLowerLimitKey = @"kPrimesTaskLowerLimitKey";
static NSString* const kPrimesTaskUpperLimitKey = @"kPrimesTaskUpperLimitKey";
static NSString* const kPrimesTaskCostKey = @"kPrimesTaskCostKey";


@interface PrimesTask()

@property (nonatomic, assign) int lowerLimit;
@property (nonatomic, assign) int upperLimit;
@property (nonatomic, assign) double cost;

@end

@implementation PrimesTask


#pragma mark - Initialization

- (instancetype)initWithLowerLimit:(int)lowerLimit
                        upperLimit:(int)upperLimit
                              cost:(double)cost {
    
    self = [super init];
    if (self) {
        _lowerLimit = lowerLimit;
        _upperLimit = upperLimit;
        _cost = cost;
    }
    return self;
}

#pragma mark - NSCoding 

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _lowerLimit = [aDecoder decodeIntForKey:kPrimesTaskLowerLimitKey];
        _upperLimit = [aDecoder decodeIntForKey:kPrimesTaskUpperLimitKey];
        _cost = [aDecoder decodeDoubleForKey:kPrimesTaskCostKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInt:_lowerLimit forKey:kPrimesTaskLowerLimitKey];
    [aCoder encodeInt:_upperLimit forKey:kPrimesTaskUpperLimitKey];
    [aCoder encodeDouble:_cost forKey:kPrimesTaskCostKey];
}

@end
