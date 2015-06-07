//
//  ApplicationSpecificViewModel.h
//  DANetworking
//
//  Created by Diomidis Papas on 07/06/2015.
//  Copyright (c) 2015 Diomidis Papas. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Robot;

@interface ApplicationSpecificViewModel : NSObject

@property (nonatomic, strong, readonly) NSMutableArray *tasks;
@property (nonatomic, strong, readonly) NSMutableArray *robots;
@property (nonatomic, strong, readonly) Robot *myRobot;

- (void)setMyRobot:(Robot *)myRobot;

- (void)sendMessageToPeers;

- (void)offlineStart;

@end
