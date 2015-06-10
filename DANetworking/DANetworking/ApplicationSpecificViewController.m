//
//  ApplicationSpecificViewController.m
//  DANetworking
//
//  Created by Diomidis Papas on 27/05/2015.
//  Copyright (c) 2015 Diomidis Papas. All rights reserved.
//

#import "ApplicationSpecificViewController.h"
#import "DANetworking-Swift.h" //Import Swift files

#import "Robot.h"
#import "RobotTask.h"

#import "DecideObserver.h"

#import "DAMessage.h"


@interface ApplicationSpecificViewController () <DecideObserverDelegate>

#pragma mark - IBOutlets

@property (weak, nonatomic, nonnull) IBOutlet UILabel *subscribersLabel;
@property (weak, nonatomic, nonnull) IBOutlet UILabel *subscribersNumberLabel;
@property (weak, nonatomic, nonnull) IBOutlet UILabel *activityLabel;


@end

@implementation ApplicationSpecificViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // I delegate the event from the
    [DecideObserver sharedInstance].delegate = self;
    
    // Create dummy environment
    [self createDummyRobots];
    [self createDummyTasks];

    // Start the process
    [[DecideObserver sharedInstance] offlineStart];

    
    // Networking initial String
    NSString *initialActivityLabelMessage = [NSString stringWithFormat:@"%@ is connected to the channel",[DANetwork sharedInstance].userIdentifier];
    
    [self updateActivityLabelWithText:initialActivityLabelMessage];
}

- (void)dealloc {
    NSLog(@"%s is deallocated", object_getClassName(self));
}


#pragma mark - ApplicationSpecificViewController

- (void)updateActivityLabelWithText:(NSString *)text {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.activityLabel.text = text;
    });
}


#pragma mark - Dummy

- (void)createDummyRobots {
    Robot *robot1 = [[Robot alloc] initWithName:@"Robot1" maxSpeed:1];
    [[DecideObserver sharedInstance] setMyRobot:robot1];

    
    Robot *robot2 = [[Robot alloc] initWithName:@"Robot2" maxSpeed:0.6];
    [[DecideObserver sharedInstance] addPeer:robot2];

    
    Robot *robot3 = [[Robot alloc] initWithName:@"Robot3" maxSpeed:0.3];
    [[DecideObserver sharedInstance] addPeer:robot3];

}

- (void)createDummyTasks {
    RobotTask *task1 = [[RobotTask alloc] initWithMeters:10];
    [[[DecideObserver sharedInstance] myRobot] addGlobalTask:task1];
    
    RobotTask *task2 = [[RobotTask alloc] initWithMeters:15];
    [[[DecideObserver sharedInstance] myRobot] addGlobalTask:task2];
    
    RobotTask *task3 = [[RobotTask alloc] initWithMeters:8];
    [[[DecideObserver sharedInstance] myRobot] addGlobalTask:task3];
    
}


#pragma mark - Actions

- (IBAction)sendMessageTypeUnknownButtonPressed:(id)sender {
    [[DecideObserver sharedInstance] sendDummyMessageToPeers];
}


#pragma mark - DecideObserverDelegate

- (void)didReceiveMessage:(DAMessage * __nonnull)message {
    NSString *labelText = [NSString stringWithFormat:@"Message received from: %@ with body: %@",message.sender , message.body];
    [self updateActivityLabelWithText:labelText];
}

- (void)didReceiveJoinEvent:(DAMessage * __nonnull)message {
    [self updateActivityLabelWithText:@"Someone joined your channel"];

}

- (void)didReceiveContributionAnalysisMessageEvent:(DAMessage * __nonnull)message {
    
}

- (void)didReceiveStatusUpdatesMessageEvent:(DAMessage * __nonnull)message {
    
}

- (void)didReceiveMajorChangeMessageEvent:(DAMessage * __nonnull)message {
    
}

@end
