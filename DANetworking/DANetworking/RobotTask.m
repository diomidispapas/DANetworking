//
//  RobotTask.m
//  DANetworking
//
//  Created by Diomidis Papas on 07/06/2015.
//  Copyright (c) 2015 Diomidis Papas. All rights reserved.
//

#import "RobotTask.h"


static NSString* const kRobotTaskMetersKey = @"kRobotTaskMeters";
static NSString* const kRobotTaskTimeKey = @"kRobotTaskTime";
static NSString* const KRobotTaskPowerConsumtionKey = @"KRobotTaskPowerConsumtion";

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

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _meters = [aDecoder decodeIntegerForKey:kRobotTaskMetersKey];
        _time = [aDecoder decodeIntegerForKey:kRobotTaskTimeKey];
        _powerConsumtion = [aDecoder decodeIntegerForKey:KRobotTaskPowerConsumtionKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeInteger:_meters forKey:kRobotTaskMetersKey];
    [aCoder encodeInteger:_time forKey:kRobotTaskTimeKey];
    [aCoder encodeInteger:_powerConsumtion forKey:KRobotTaskPowerConsumtionKey];
}



@end
