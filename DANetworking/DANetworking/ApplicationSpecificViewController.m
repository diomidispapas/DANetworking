//
//  ApplicationSpecificViewController.m
//  DANetworking
//
//  Created by Diomidis Papas on 27/05/2015.
//  Copyright (c) 2015 Diomidis Papas. All rights reserved.
//

#import "ApplicationSpecificViewController.h"
#import "ApplicationSpecificViewModel.h"
#import "DANetworking-Swift.h" //Import Swift files

#import "Robot.h"

#import "DANetwork.h"
#import "DAMessage.h"


@interface ApplicationSpecificViewController () <DANetworkDelegate>

#pragma mark - IBOutlets

@property (weak, nonatomic, nonnull) IBOutlet UILabel *subscribersLabel;
@property (weak, nonatomic, nonnull) IBOutlet UILabel *subscribersNumberLabel;
@property (weak, nonatomic, nonnull) IBOutlet UILabel *activityLabel;

@property (strong, nonatomic, nonnull) ApplicationSpecificViewModel *viewModel;

@end

@implementation ApplicationSpecificViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [DANetwork sharedInstance].delegate = self;
    
    _viewModel = [[ApplicationSpecificViewModel alloc] init];
    
    [_viewModel offlineStart];
    
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


#pragma mark - Actions

- (IBAction)sendMessageTypeUnknownButtonPressed:(id)sender {
    [_viewModel sendMessageToPeers];
}


#pragma mark - <DANetworkDelegate>

- (void)didReceiveMessage:(DAMessage *)message {
    NSString *labelText = [NSString stringWithFormat:@"Message received from: %@ with body: %@",message.sender , message.body];
    [self updateActivityLabelWithText:labelText];
}

- (void)didReceiveJoinEvent:(DAMessage *)message {
    [self updateActivityLabelWithText:@"Someone joined your channel"];
}

@end
