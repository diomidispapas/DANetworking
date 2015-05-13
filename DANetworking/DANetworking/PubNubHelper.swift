//
//  PubNubHelper.swift
//  DANetworking
//
//  Created by Diomidis Papas on 12/05/2015.
//  Copyright (c) 2015 Diomidis Papas. All rights reserved.
//

import Foundation


class PubNubHelper: NSObject {
    
    static let sharedInstance : PubNubHelper = PubNubHelper()
    
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
                competionHandler(sucess: false, error: nil)
                println("There should be a reason because of which subscription failed and it can be found in 'error' instance")
            case 1: // PNSubscriptionProcessSubscribedState
                // PubNub client completed subscription on specified set of channels.
                competionHandler(sucess: true, error: nil)
                println("PubNub client completed subscription on specified set of channels.")
            default:
                println("Other case of subscription")
                competionHandler(sucess: false, error: nil)

            }
        })
    }
    
    func sendMessage(message: String, channel: PNChannel, completionHandler: (sucess: Bool, error: PNError?) -> Void) {
        
        PubNub.sendMessage(message, toChannel: channel) { (state: PNMessageState, data: AnyObject!) -> Void in
            switch (state.rawValue) {
            case 0:
                println("senting")
            case 1:
                println("sent")
                completionHandler(sucess: true, error: nil)
            case 2:
                println("error")
                completionHandler(sucess: false, error: nil)
            default:
                println("Other case of sending")
                completionHandler(sucess: false, error: nil)
            }
        }
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