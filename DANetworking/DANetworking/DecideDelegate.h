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
 *  When joining a distributed self-adaptive system and after major environment and internal changes, the DECIDE component uses runtime quantitative verification locally, to establish its expected range of QoS attributes. The result of this analysis is a capability summary, i.e., a finite set of possible contributions that the component could make towards achieving the QoS requirements of the system. These contributions are associated with different modes of operation that the component can assume, and with different costs. This stage is executed infrequently (e.g., when the component joins the system)

 */
- (void)localCapabilityAnalysis;

/**
 *  On start-up and after major changes experienced by peer components, the component receives peer capability summaries. DECIDE capability summary calculation and communication overheads are made acceptable for a given system by fine tuning the local capability analysis carried out by each component. Informally, this analysis is sufficiently conservative to ensure that "major changes" occur with a low frequency at which these overheads represent only small fractions of the component compute resources and system bandwidth, respectively. The capability summary is shared with the peer components

 */
- (void)receiveRemoteNodesCapabilities;

/**
 *  This DECIDE stage is performed by a component each time when there is a change to a capability summary, whether the local one or that of a peer. As a result, the component selects one of the possible contributions in its local capability summary as its contribution-level agreement (CLA). The CLA selection is carried out locally by each component, such that the system complies with its QoS requirements as long as each component achieves its CLA. This stage is executed infrequently (e.g., when the component joins the system)

 */
- (void)selectionOfLocalContribution;

/**
 *  Most of the time, this is the only stage of the DECIDE workflow that a component needs to execute. Its purpose is to ensure compliance with the selected component CLA.

 */
- (void)executionOfControlLoop;

/**
 * Infrequently, events such as signifi- cant workload increases or failures of component parts render a DECIDE local control loop unable to achieve its CLA.
 */
- (void)majorChange;

@end
