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

@end

@implementation RobotTask

- (instancetype)initWithMeters:(NSInteger)meters {
    
    self = [super init];
    if (self) {
        _meters = meters;
    }
    return self;
}

@end
