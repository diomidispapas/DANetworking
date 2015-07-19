//
//  RobotTask.h
//  DANetworking
//
//  Created by Diomidis Papas on 07/06/2015.
//  Copyright (c) 2015 Diomidis Papas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RobotTask : NSObject <NSCoding>

@property (nonatomic, assign, readonly) NSInteger meters;
@property (nonatomic, assign, readonly) NSInteger time;
@property (nonatomic, assign, readonly) NSInteger powerConsumtion;


#pragma mark - Initialization

- (instancetype)initWithMeters:(NSInteger)meters
                          time:(NSInteger)time
               powerConsumtion:(NSInteger)powerConsumtion;

@end
