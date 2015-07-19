//
//  PrimesTask.h
//  DANetworking
//
//  Created by Diomidis Papas on 19/07/2015.
//  Copyright (c) 2015 Diomidis Papas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DecideTask.h"

@interface PrimesTask : DecideTask

@property (nonatomic, assign, readonly) int lowerLimit;
@property (nonatomic, assign, readonly) int upperLimit;

- (instancetype)initWithLowerLimit:(int)lowerLimit
                        upperLimit:(int)upperLimit;
@end
