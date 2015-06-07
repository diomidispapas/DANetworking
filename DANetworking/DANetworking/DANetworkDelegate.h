//
//  DANetworkDelegate.h
//  DANetworking
//
//  Created by Diomidis Papas on 27/05/2015.
//  Copyright (c) 2015 Diomidis Papas. All rights reserved.
//

@import Foundation;

@class DAMessage;

@protocol DANetworkDelegate <NSObject>

@optional
- (void)didReceiveMessage:(DAMessage * __nonnull)message;
- (void)didReceiveJoinEvent:(DAMessage * __nonnull)message;

@end
