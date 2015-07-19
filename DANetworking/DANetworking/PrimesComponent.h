//
//  PrimesComponent.h
//  DANetworking
//
//  Created by Diomidis Papas on 19/07/2015.
//  Copyright (c) 2015 Diomidis Papas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DecideComponent.h"

@interface PrimesComponent : DecideComponent

@property (nonatomic, assign, readonly) double maxPowerConsumtion;
@property (nonatomic, assign, readonly) double powerConsumtionPerSec;

- (instancetype)initWithIdentifier:(NSString *)identifier
                maxPowerConsumtion:(double)maxPowerConsumtion
             powerConsumtionPerSec:(double)powerConsumtionPerSec;

@end
