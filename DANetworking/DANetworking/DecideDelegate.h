//
//  DecideDelegate.h
//  DANetworking
//
//  Created by Diomidis Papas on 07/06/2015.
//  Copyright (c) 2015 Diomidis Papas. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  This protocol must be implemented by the user
 */
@protocol DecideDelegate <NSObject>

@required
/**
 * This stage is executed infrequently (e.g., when the component joins the system)
 */
- (void)localCapabilityAnalysis;

/**
 * The capability summary is shared with the peer components
 */
- (void)receiveRemoteNodesCapabilities;

/**
 * This stage is executed infrequently (e.g., when the component joins the system)
 */
- (void)selectionOfLocalContribution;

/**
 * Most of the time, the execution of a local control loop is the only DECIDE stage carried out by a component.
 */
- (void)executionOfControlLoop;

/**
 * Infrequently, events such as signifi- cant workload increases or failures of component parts render a DECIDE local control loop unable to achieve its CLA.
 */
- (void)majorChange;

@end
