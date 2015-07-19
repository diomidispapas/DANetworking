//
//  PrimesTask.h
//  DANetworking
//
//  Created by Diomidis Papas on 19/07/2015.
//  Copyright (c) 2015 Diomidis Papas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DecideTask.h"

/**
 *  PrimesTask class represents an actual excecution task. It inherits the DECIDE functionallity from the DecideTask.h class.
 *  @see @code DecideTask.h @endcode
 */
@interface PrimesTask : DecideTask

@property (nonatomic, assign, readonly) int lowerLimit;
@property (nonatomic, assign, readonly) int upperLimit;

- (instancetype)initWithLowerLimit:(int)lowerLimit
                        upperLimit:(int)upperLimit;
@end
