//
//  DecideObserverDelegate.h
//  DANetworking
//
//  Created by Diomidis Papas on 19/07/2015.
//  Copyright (c) 2015 Diomidis Papas. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DAMessage;
@class DecideComponent;

@protocol DecideObserverDelegate <NSObject>

/**
 *  It is called in order to calculate the local capability analysis.
 *  When joining a distributed self-adaptive system and after major environment and internal changes, the DECIDE component uses runtime quantitative verification locally, to establish its expected range of QoS attributes. The result of this analysis is a capability summary, i.e., a finite set of possible contributions that the component could make towards achieving the QoS requirements of the system. These contributions are associated with different modes of operation that the component can assume, and with different costs. This stage is executed infrequently (e.g., when the component joins the system)
 *  @see @code DecideDelegate.h @endcode
 *  @return an array with the local capability analysis
 */
- (NSArray * __nonnull)localCapabilitiesAnalysisCalculation;

/**
 *  This DECIDE stage is performed by a component each time when there is a change to a capability summary, whether the local one or that of a peer. As a result, the component selects one of the possible contributions in its local capability summary as its contribution-level agreement (CLA). The CLA selection is carried out locally by each component, such that the system complies with its QoS requirements as long as each component achieves its CLA. This stage is executed infrequently (e.g., when the component joins the system)
 *  @see @code DecideDelegate.h @endcode
 *  @param combinations an array of all the combinations
 */
- (NSMutableArray * __nonnull)calculatePossibleCombinations;

/**
 *  
 *  On start-up and after major changes experienced by peer components, the component receives peer capability summaries. DECIDE capability summary calculation and communication overheads are made acceptable for a given system by fine tuning the local capability analysis carried out by each component. Informally, this analysis is sufficiently conservative to ensure that "major changes" occur with a low frequency at which these overheads represent only small fractions of the component compute resources and system bandwidth, respectively. The capability summary is shared with the peer components
 *  It is called when a component joins the channel. The joining message contains all the information about the component.
 *
 *  @param message the DAMessage with the component's information including the local capability analysis
 *  @see @code DecideDelegate.h @endcode
 *  @return an object of the application spesific type
 */
- (DecideComponent * __nullable)didReceiveContributionAnalysisMessageEvent:(DAMessage * __nonnull)message;

/**
 *  Information function that indicates the status of the DECIDE process
 *
 *  @param status a description string
 */
- (void)didChangeDecideStatus:(NSString * __nonnull)status;

/**
 *  It is called when a new component joins the channel (DEPRECATED)
 *
 *  @param message the DAMessage of type Joining_Message
 */
- (void)didReceiveJoinEvent:(DAMessage * __nonnull)message NS_DEPRECATED(10_0, 10_6, 2_0, 4_0);

/**
 *  The actual logic excecution
 */
- (void)execution;

/**
 *  Unused
 *
 *  @param message <#message description#>
 */
- (void)didReceiveStatusUpdatesMessageEvent:(DAMessage * __nonnull)message NS_DEPRECATED(10_0, 10_6, 2_0, 4_0);

/**
 *  Unused
 *
 *  @param message <#message description#>
 */
- (void)didReceiveMajorChangeMessageEvent:(DAMessage * __nonnull)messageNS_DEPRECATED(10_0, 10_6, 2_0, 4_0);

@end
