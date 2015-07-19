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

@interface PrimesTask()

@property (nonatomic, assign) int lowerLimit;
@property (nonatomic, assign) int upperLimit;

@end

@implementation PrimesTask


#pragma mark - Initialization

- (instancetype)initWithLowerLimit:(int)lowerLimit
                        upperLimit:(int)upperLimit {
    
    self = [super init];
    if (self) {
        _lowerLimit = lowerLimit;
        _upperLimit = upperLimit;
    }
    return self;
}

#pragma mark - NSCoding 

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _lowerLimit = [aDecoder decodeIntForKey:kPrimesTaskLowerLimitKey];
        _upperLimit = [aDecoder decodeIntForKey:kPrimesTaskUpperLimitKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeInt:_lowerLimit forKey:kPrimesTaskLowerLimitKey];
    [aCoder encodeInt:_upperLimit forKey:kPrimesTaskUpperLimitKey];
}

@end
