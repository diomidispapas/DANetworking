//
//  PrimesComponent.m
//  DANetworking
//
//  Created by Diomidis Papas on 19/07/2015.
//  Copyright (c) 2015 Diomidis Papas. All rights reserved.
//

#import "PrimesComponent.h"

@interface PrimesComponent ()

@property (nonatomic, assign) double maxPowerConsumtion;
@property (nonatomic, assign) double powerConsumtionPerSec;

@end


@implementation PrimesComponent


#pragma mark - Initialization

- (instancetype)initWithIdentifier:(NSString *)identifier
                maxPowerConsumtion:(double)maxPowerConsumtion
             powerConsumtionPerSec:(double)powerConsumtionPerSec {
    self = [super initWithIdentifier:identifier];
    if (self) {
        _maxPowerConsumtion = maxPowerConsumtion;
        _powerConsumtionPerSec = powerConsumtionPerSec;
    }
    return self;
}

@end
