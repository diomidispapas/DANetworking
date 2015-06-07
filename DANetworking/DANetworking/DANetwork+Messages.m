//
//  DANetwork+Messages.m
//  DANetworking
//
//  Created by Diomidis Papas on 07/06/2015.
//  Copyright (c) 2015 Diomidis Papas. All rights reserved.
//

#import "DANetwork+Messages.h"
#import "DAMessage.h"

@implementation DANetwork (Messages)


- (void)sendJoiningMessageWithCompletionBlock:(void(^)(BOOL sucess, NSError *error))completion {
    
    switch (self.serviceType) {
        case ServiceTypePubNubService: {
            
            DAMessage *joiningMessage = [[DAMessage alloc] initWithMessageId:@"1" sender:self.userIdentifier messageType:MessageTypeJoiningMessage body:@"Joining message"];
            
            [self sendMessage:joiningMessage completionBlock:^(BOOL success, NSError * __nullable error) {
                if (error) {
                    completion(NO, error);
                }
                
                completion(YES, nil);
            }];
        }
        default:
            return;
    }
}


@end
