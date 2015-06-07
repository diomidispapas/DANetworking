//
//  RobotTask.h
//  DANetworking
//
//  Created by Diomidis Papas on 07/06/2015.
//  Copyright (c) 2015 Diomidis Papas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RobotTask : NSObject

@property (nonatomic, assign, readonly) NSInteger meters;

- (instancetype)initWithMeters:(NSInteger)meters;

@end
