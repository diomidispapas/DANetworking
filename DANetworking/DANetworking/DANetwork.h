//
//  DANetwork.h
//  DANetworking
//
//  Created by Diomidis Papas on 27/05/2015.
//  Copyright (c) 2015 Diomidis Papas. All rights reserved.
//

@import Foundation;

#import "DANetworkDelegate.h"

@class DAMessage;
@class PubNub;


typedef NS_ENUM(NSUInteger, ServiceType) {
    ServiceTypePubNubService,
    ServiceTypeMatrixService,
};

@interface DANetwork : NSObject

@property (nonatomic, assign) ServiceType serviceType;

@property (nonatomic, weak) __nullable id  <DANetworkDelegate> delegate;

@property (nonatomic, strong, nullable, readonly) NSString *userIdentifier;

@property (nonatomic, strong, nullable, readonly) NSMutableArray *participants;

+ (nullable instancetype)sharedInstance;

- (void)subscribeUser:(NSString * __nonnull)userIdentifier
    toChannelWithName:(NSString * __nonnull)channelName
      completionBlock:(void(^ __nonnull)(BOOL success, NSError * __nullable error))completion;

- (void)sendMessage:(DAMessage * __nonnull)message
    completionBlock:(void(^ __nonnull)(BOOL success, NSError * __nullable error))completion;

@end
