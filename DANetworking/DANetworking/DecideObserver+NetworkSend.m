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
    DAMessage *message = [[DAMessage alloc] initWithMessageId:@"000" sender:self.myComponent.identifier messageType:MessageTypeUnknown body:@"Testing_Connection"];
    [self sendMessageToPeers:message];
}

- (void)sendCLAMessageToPeersWithBody:(NSArray *)localCapabilityAnalysisArray {
    DAMessage *message = [[DAMessage alloc] initWithMessageId:@"LCA_Message" sender:self.myComponent.identifier messageType:MessageTypeContributionAnalysisMessage body:@"NULL"];
    
    message.lcaBody = localCapabilityAnalysisArray;
    
    [self sendMessageToPeers:message];
}

- (void)sendUpdateMessageToPeers {
    DAMessage *message = [[DAMessage alloc] initWithMessageId:@"UpdateMessage" sender:self.myComponent.identifier messageType:MessageTypeStatusUpdateMessage body:@"NULL"];
    [self sendMessageToPeers:message];
}

- (void)sendChangeMessageToPeers {
    DAMessage *message = [[DAMessage alloc] initWithMessageId:@"ChangeMessage" sender:self.myComponent.identifier messageType:MessageTypeMajorChangeMessage body:@"NULL"];
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
