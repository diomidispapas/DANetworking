//
//  DecideObserver+NetworkSend.h
//  DANetworking
//
//  Created by Diomidis Papas on 14/06/2015.
//  Copyright (c) 2015 Diomidis Papas. All rights reserved.
//

#import "DecideObserver.h"

@interface DecideObserver (NetworkSend)

- (void)sendDummyMessageToPeers;
- (void)sendCLAMessageToPeersWithBody:(NSArray *)localCapabilityAnalysisArray;
- (void)sendUpdateMessageToPeers;
- (void)sendChangeMessageToPeers;


@end
