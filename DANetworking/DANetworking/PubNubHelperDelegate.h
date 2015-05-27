//
//  PubNubHelperDelegate.h
//  DANetworking
//
//  Created by Diomidis Papas on 27/05/2015.
//  Copyright (c) 2015 Diomidis Papas. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PubNub;

@protocol PubNubHelperDelegate <NSObject>
- (void)didReceiveMessage:(PNMessage *)message;
- (void)didReceiveJoinEvent;
@end
