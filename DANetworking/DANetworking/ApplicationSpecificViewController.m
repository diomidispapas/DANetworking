//
//  ApplicationSpecificViewController.m
//  DANetworking
//
//  Created by Diomidis Papas on 27/05/2015.
//  Copyright (c) 2015 Diomidis Papas. All rights reserved.
//

#import "ApplicationSpecificViewController.h"
#import "DANetworking-Swift.h" //Import Swift files

#import "DecideObserver.h"
#import "Robot.h"

#import "DANetwork.h"
#import "DAMessage.h"

@interface ApplicationSpecificViewController () <DANetworkDelegate>

#pragma mark - IBOutlets

@property (weak, nonatomic, nonnull) IBOutlet UILabel *subscribersLabel;
@property (weak, nonatomic, nonnull) IBOutlet UILabel *subscribersNumberLabel;
@property (weak, nonatomic, nonnull) IBOutlet UILabel *activityLabel;

@end

@implementation ApplicationSpecificViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [DANetwork sharedInstance].delegate = self;
    
    [self setUpApplicationSpecificAssets];
    
    NSString *initialActivityLabelMessage = [NSString stringWithFormat:@"%@ is connected to the channel",[DANetwork sharedInstance].userIdentifier];
    [self updateActivityLabelWithText:initialActivityLabelMessage];
}



- (void)dealloc {
    NSLog(@"%s is deallocated", object_getClassName(self));
}


#pragma mark - ApplicationSpecificViewController

- (void)setUpApplicationSpecificAssets {
    // Set up my robot
    Robot *myRobot = [[Robot alloc] initWithName:[DANetwork sharedInstance].userIdentifier speed:1.2];
    [[DecideObserver sharedInstance]setMyRobot:myRobot];
    
    // Set up peers
    /*
    for (NSString* participant in [DANetwork sharedInstance].) {
        Robot *peer = [[Robot alloc] initWithName:participant speed:0.8];
        [[DecideObserver sharedInstance] addPeer:peer];
    }
    */
    [self setUpSubscribersLabel];
}

- (void)setUpSubscribersLabel {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMutableString *subscribers = [NSMutableString stringWithString:[DecideObserver sharedInstance].myRobot.name];
        for (Robot *peer in [DecideObserver sharedInstance].robots) {
            [subscribers appendFormat:@", %@",peer.name];
        }
        self.subscribersLabel.text = subscribers;
        self.subscribersNumberLabel.text = [NSString stringWithFormat:@"%lu", [DANetwork sharedInstance].participants.count];
    });
}

- (void)updateActivityLabelWithText:(NSString *)text {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.activityLabel.text = text;
    });
}

- (IBAction)sendMessageTypeUnknownButtonPressed:(id)sender {
    [[DecideObserver sharedInstance] sendDummyMessageToPeers];
}



#pragma mark - <DANetworkDelegate>

- (void)didReceiveMessage:(DAMessage *)message {
    NSString *labelText = [NSString stringWithFormat:@"Message received from: %@ with body: %@",message.sender , message.body];
    [self updateActivityLabelWithText:labelText];
}

- (void)didReceiveJoinEvent:(DAMessage *)message {
    [self updateActivityLabelWithText:@"Someone joined your channel"];
    [self setUpSubscribersLabel];
}

@end
