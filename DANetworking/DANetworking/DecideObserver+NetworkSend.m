//
//  DecideObserver+NetworkSend.m
//  DANetworking
//
//  Created by Diomidis Papas on 14/06/2015.
//  Copyright (c) 2015 Diomidis Papas. All rights reserved.
//

#import "DecideObserver+NetworkSend.h"
#import "DecideObserver.h"

#import "DANetwork.h"
#import "DAMessage.h"
#import "Robot.h"


@implementation DecideObserver (NetworkSend)

#pragma mark - Networking

- (void)sendDummyMessageToPeers {
    DAMessage *message = [[DAMessage alloc] initWithMessageId:@"DummyMessage" sender:self.myRobot.name messageType:MessageTypeUnknown body:@"Hello guys"];
    [self sendMessageToPeers:message];
}

- (void)sendCLAMessageToPeersWithBody:(NSArray *)localCapabilityAnalysisArray {
    DAMessage *message = [[DAMessage alloc] initWithMessageId:@"CLAMessage" sender:self.myRobot.name messageType:MessageTypeContributionAnalysisMessage body:@"NULL"];
    
    message.lcaBody = localCapabilityAnalysisArray;
    
    [self sendMessageToPeers:message];
}

- (void)sendUpdateMessageToPeers {
    DAMessage *message = [[DAMessage alloc] initWithMessageId:@"UpdateMessage" sender:self.myRobot.name messageType:MessageTypeStatusUpdateMessage body:@"Hello guys"];
    [self sendMessageToPeers:message];
}

- (void)sendChangeMessageToPeers {
    DAMessage *message = [[DAMessage alloc] initWithMessageId:@"ChangeMessage" sender:self.myRobot.name messageType:MessageTypeMajorChangeMessage body:@"Hello guys"];
    [self sendMessageToPeers:message];
}


#pragma mark - Private methods

- (void)sendMessageToPeers:(DAMessage * __nonnull)message {
    [[DANetwork sharedInstance] sendMessage:message completionBlock:^(BOOL success, NSError * __nullable error) {
        if (error) {
            
        }
        
        if (success) {
            
        }
        
    }];
}

@end
