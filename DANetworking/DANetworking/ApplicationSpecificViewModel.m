//
//  ApplicationSpecificViewModel.m
//  DANetworking
//
//  Created by Diomidis Papas on 07/06/2015.
//  Copyright (c) 2015 Diomidis Papas. All rights reserved.
//

#import "ApplicationSpecificViewModel.h"

#import "DecideObserver.h"
#import "Robot.h"
#import "RobotTask.h"

@interface ApplicationSpecificViewModel ()

@property (nonatomic, strong) NSMutableArray *tasks;
@property (nonatomic, strong) NSMutableArray *robots;
@property (nonatomic, strong) Robot *myRobot;

@end

@implementation ApplicationSpecificViewModel


#pragma mark - Initialization

- (instancetype)init {
    self = [super init];
    if (self) {
        _tasks = [NSMutableArray array];
        _robots = [NSMutableArray array];
    }
    [self createDummyTasks];
    [self createDummyRobots];
    return self;
}


#pragma mark - Task

- (void)createDummyTasks {
    RobotTask *task1 = [[RobotTask alloc] initWithMeters:10];
    [_tasks addObject:task1];
    [[DecideObserver sharedInstance] addTask:task1];
    
    RobotTask *task2 = [[RobotTask alloc] initWithMeters:15];
    [_tasks addObject:task2];
    [[DecideObserver sharedInstance] addTask:task2];

    RobotTask *task3 = [[RobotTask alloc] initWithMeters:8];
    [_tasks addObject:task3];
    [[DecideObserver sharedInstance] addTask:task3];

}



#pragma mark - Robot

- (void)createDummyRobots {
    Robot *robot1 = [[Robot alloc] initWithName:@"Robot1" maxSpeed:1];
    [_robots addObject:robot1];
    [self setMyRobot:robot1];

    Robot *robot2 = [[Robot alloc] initWithName:@"Robot2" maxSpeed:0.6];
    [_robots addObject:robot2];
    [[DecideObserver sharedInstance] addPeer:robot2];

    Robot *robot3 = [[Robot alloc] initWithName:@"Robot3" maxSpeed:0.3];
    [_robots addObject:robot3];
    [[DecideObserver sharedInstance] addPeer:robot3];
}

- (void)setMyRobot:(Robot *)myRobot {
    _myRobot = myRobot;
    [[DecideObserver sharedInstance] setMyRobot:myRobot];
}

- (void)sendMessageToPeers {
    [[DecideObserver sharedInstance] sendDummyMessageToPeers];
}


#pragma mark - Decide Lifecycle

- (void)offlineStart {
    [[DecideObserver sharedInstance] offlineStart];
}

@end
