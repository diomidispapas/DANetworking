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


@property (weak, nonatomic) IBOutlet UIButton *sendDummyMessageButton;
@property (weak, nonatomic) IBOutlet UIButton *startDecideButton;

@property (weak, nonatomic) IBOutlet UILabel *speedLabel;
@property (weak, nonatomic) IBOutlet UILabel *powerConsumptionLabel;

@property (weak, nonatomic) IBOutlet UISlider *speedSlider;
@property (weak, nonatomic) IBOutlet UISlider *powerConsumtionSlider;

@end

@implementation ApplicationSpecificViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // I delegate the event from the
    [DecideObserver sharedInstance].delegate = self;
    
    // Create environment
    [self createGlobalTask];
    
    // Deprecated
    // Create dummy environment
    //[self createDummyRobots];
    
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

// Deprecated
- (void)createDummyRobots {
    
    Robot *robot1 = [[Robot alloc] initWithName:@"Robot1" maxSpeed:5 powerConsumtionPerSec:1] ;
    [[DecideObserver sharedInstance] setMyRobot:robot1];

    
    Robot *robot2 = [[Robot alloc] initWithName:@"Robot2" maxSpeed:1 powerConsumtionPerSec:2];
    [[DecideObserver sharedInstance] addPeer:robot2];

    
    Robot *robot3 = [[Robot alloc] initWithName:@"Robot3" maxSpeed:0.3 powerConsumtionPerSec:3];
    [[DecideObserver sharedInstance] addPeer:robot3];

}

- (void)createGlobalTask {
    
    // Create a global task that will be divided into the components.
    RobotTask *globalTask = [[RobotTask alloc] initWithMeters:100 time:50 powerConsumtion:20];
    [[[DecideObserver sharedInstance] myRobot] addGlobalTask:globalTask];
    
}


#pragma mark - Actions

- (IBAction)sendMessageTypeUnknownButtonPressed:(id)sender {
    [[DecideObserver sharedInstance] sendDummyMessageToPeers];
}

- (IBAction)speedSliderValueChanged:(UISlider *)sender {
    _speedLabel.text = [NSString stringWithFormat:@"%.02g", sender.value];
}

- (IBAction)powerConsumptionValueChanged:(UISlider *)sender {
    _powerConsumptionLabel.text = [NSString stringWithFormat:@"%.02g", sender.value];
}

- (IBAction)startDecideButtonPressed:(id)sender {
    // Create the robot instance
    Robot *myRobot = [[Robot alloc] initWithName:@"Robot1" maxSpeed:[_speedLabel.text doubleValue] powerConsumtionPerSec:[_powerConsumptionLabel.text doubleValue]];
    
    // Set this as my robot to the observer
    [[DecideObserver sharedInstance] setMyRobot:myRobot];
    
    // Start the process
    [[DecideObserver sharedInstance] start];
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
