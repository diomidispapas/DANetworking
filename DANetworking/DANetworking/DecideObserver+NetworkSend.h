//
//  DecideObserver+NetworkSend.h
//  DANetworking
//
//  Created by Diomidis Papas on 14/06/2015.
//  Copyright (c) 2015 Diomidis Papas. All rights reserved.
//

#import "DecideObserver.h"

@interface DecideObserver (NetworkSend)

- (void)sendLocalCapabilitySummaryToPeersWithBody:(NSArray *)localCapabilityAnalysisArray;

- (void)sendDummyMessageToPeers NS_DEPRECATED(10_0, 10_6, 2_0, 4_0);
- (void)sendUpdateMessageToPeers NS_DEPRECATED(10_0, 10_6, 2_0, 4_0);
- (void)sendChangeMessageToPeers NS_DEPRECATED(10_0, 10_6, 2_0, 4_0);

@end
