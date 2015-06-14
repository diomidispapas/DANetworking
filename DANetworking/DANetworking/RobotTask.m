//
//  RobotTask.m
//  DANetworking
//
//  Created by Diomidis Papas on 07/06/2015.
//  Copyright (c) 2015 Diomidis Papas. All rights reserved.
//

#import "RobotTask.h"

@interface RobotTask ()

@property (nonatomic, assign) NSInteger meters;
@property (nonatomic, assign) NSInteger time;
@property (nonatomic, assign) NSInteger powerConsumtion;

@end

@implementation RobotTask

- (instancetype)initWithMeters:(NSInteger)meters
                          time:(NSInteger)time
               powerConsumtion:(NSInteger)powerConsumtion {
    
    self = [super init];
    if (self) {
        _meters = meters;
        _time = time;
        _powerConsumtion = powerConsumtion;
    }
    return self;
}

@end
