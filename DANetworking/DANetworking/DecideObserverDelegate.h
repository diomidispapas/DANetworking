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
 *  It is called in order to calculate the local capability analysis
 *
 *  @return an array with the local capability analysis
 */
- (NSArray * __nonnull)localCapabilitiesAnalysisCalculation;

/**
 *  It is an information function in order to get the possible excecution combinations when they are ready
 *
 *  @param combinations an array of all the combinations
 */
- (NSMutableArray *)calculatePossibleCombinations;

/**
 *  It is called when a component jois the channel. The joining message contains all the information about the component.
 *
 *  @param message the DAMessage with the component's information including the local capability analysis
 *
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
- (void)didReceiveJoinEvent:(DAMessage * __nonnull)message;

/**
 *  The actual logic excecution
 */
- (void)execution;

/**
 *  Unused
 *
 *  @param message <#message description#>
 */
- (void)didReceiveStatusUpdatesMessageEvent:(DAMessage * __nonnull)message;

/**
 *  Unused
 *
 *  @param message <#message description#>
 */
- (void)didReceiveMajorChangeMessageEvent:(DAMessage * __nonnull)message;

@end
