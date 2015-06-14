//
//  PubNubHelper.swift
//  DANetworking
//
//  Created by Diomidis Papas on 12/05/2015.
//  Copyright (c) 2015 Diomidis Papas. All rights reserved.
//

import Foundation

@objc (PubNubHelper)
class PubNubHelper: NSObject, PNDelegate {
    
    static let sharedInstance : PubNubHelper = PubNubHelper()
    weak var delegate: PubNubHelperDelegate?
    
    func subscribe(channelObjects :[AnyObject], competionHandler: (sucess: Bool, error: PNError?) -> Void) {
        PubNub.subscribeOn(channelObjects, withCompletionHandlingBlock: { (state: PNSubscriptionProcessState, channels: [AnyObject]!, error :PNError!) -> Void in
            
            // Check for error and propagate
            if error != nil {
                competionHandler(sucess: false, error: error)
            }
            
            // Otherwise handle the response state
            switch state.rawValue {
            case 0: // PNSubscriptionProcessNotSubscribedState
                // There should be a reason because of which subscription failed and it can be found in 'error' instance
                #if DEBUG
                    println("There should be a reason because of which subscription failed and it can be found in 'error' instance")
                #endif
                competionHandler(sucess: false, error: nil)
            case 1: // PNSubscriptionProcessSubscribedState
                // PubNub client completed subscription on specified set of channels.
                #if DEBUG
                    println("PubNub client completed subscription on specified set of channels.")
                #endif
                PubNub.sharedInstance().setDelegate(self)
                competionHandler(sucess: true, error: nil)
            default:
                #if DEBUG
                    println("Other case of subscription")
                #endif
                competionHandler(sucess: false, error: nil)
            }
        })
    }
    
    func sendMessage(message: NSData, channel: PNChannel, completionHandler: (sucess: Bool, error: PNError?) -> Void) {
        
        PubNub.sendMessage(message, toChannel: channel) { (state: PNMessageState, data: AnyObject!) -> Void in
            switch (state.rawValue) {
            case 0:
                #if DEBUG
                    println("PubNub: Sending...")
                #endif
            case 1:
                #if DEBUG
                    println("PubNub: Sent")
                #endif
                completionHandler(sucess: true, error: nil)
            case 2:
                #if DEBUG
                    println("PubNub: Error sending message")
                #endif
                completionHandler(sucess: false, error: nil)
            default:
                #if DEBUG
                    println("PubNub: Other case of sending")
                #endif
                completionHandler(sucess: false, error: nil)
            }
        }
    }
    
    
    // MARK: PNDelegate

    func pubnubClient(client: PubNub!, didReceiveMessage message: PNMessage!) {
        self.delegate!.didReceiveMessage(message)
    }

    func pubnubClient(client: PubNub!, didReceivePresenceEvent event: PNPresenceEvent!) {
        switch event.type.rawValue {
        case 0: //// Number of persons changed in observed channel, PNPresenceEventChanged
            return
        case 1:
            return
        case 2: //PNPresenceEventJoin
            self.delegate!.didReceiveJoinEvent()
        default:
            return
        }
    }
    
    
    func pubnubClient(client: PubNub!, didReceiveParticipants presenceInformation: PNHereNow!, forObjects channelObjects: [AnyObject]!) {
        #if DEBUG
            println(presenceInformation.participantsCountForChannel(channelObjects))
        #endif
    }
}



extension PubNubHelper {
    /**
    *  Configuration Constants for PubNub Service
    */
    struct Constancts {
        static let origin = "pubsub.pubnub.com"
        static let publishKey = "pub-c-67de65fa-5cb0-425f-95b4-47afa307fbd7"
        static let subscribeKey = "sub-c-a4faccfc-f8a8-11e4-9098-0619f8945a4f"
        static let secretKey = "sec-c-OGQyMGQ3ZDItNDFkNy00ZTk0LWE2YTAtMzI0ZjA2ZmM1ODNi"
    }
    
    struct ErrorMessages {
        static let errorSubscribing = "Something went wrong during the subscription process"
        static let errorSendingMessage = "I am sorry I couldnt sent your message. Please try again"
    }
    
    struct ActivityMessages {
        static let subscriptionSuccefullyCompleted = "Subscription has succefully completed"
        static let messageSuccefullySent = "Your message has succefully sent"
    }
}