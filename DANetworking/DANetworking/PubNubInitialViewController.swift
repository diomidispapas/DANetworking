//
//  PubNubInitialViewController.swift
//  DANetworking
//
//  Created by Diomidis Papas on 12/05/2015.
//  Copyright (c) 2015 Diomidis Papas. All rights reserved.
//

import UIKit

class PubNubInitialViewController: UIViewController {
    
    // MARK: Properties
    var pubNub: PubNub?
    var channel: PNChannel?
    var username: String?
    
    
    // MARK: Outlets
    
    @IBOutlet weak var activityLabel: UILabel!
    
    @IBOutlet weak var messageTextField: UITextField!
    
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var joinNetworkButton: UIButton!
    
    @IBOutlet weak var proceedToSampleAppButton: UIButton!
    
    
    //MARK: UIViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Disable send button
        self.sendButton.enabled = true
        self.joinNetworkButton.enabled = false
        self.proceedToSampleAppButton.enabled = false
        
        
        /*
        // Subscribe to PubNub
        var channels = [PNChannel]()
        self.channel = PNChannel.channelWithName("demo_tutorial", shouldObservePresence: true) as? PNChannel
        channels.append(self.channel!)
        
        // Make the request
        PubNubHelper.sharedInstance.subscribe(channels, competionHandler: { (sucess, error) -> Void in
            if (error != nil) {
                self.updateActivityLabel(text: PubNubHelper.ErrorMessages.errorSubscribing)
            }
            else {
                self.updateActivityLabel(text: PubNubHelper.ActivityMessages.subscriptionSuccefullyCompleted)
                self.sendButton.enabled = true
            }
        })
        */
        
        /*
        // Get the pubnub instance
        self.pubNub = PubNub.sharedInstance()
        
        // Add observer
        self.pubNub?.observationCenter.addMessageReceiveObserver(self, withBlock: { (message:PNMessage!) -> Void in
            if  (message != nil) {
                var messageString :String = message.message as! String
                
                self.updateActivityLabel(text:"Message received: " + messageString)
            }
        })
        */
    }
    
    deinit {
        println(" \(object_getClassName(self)) is deallocated")
    }
    
    
    // MARK: PubNubInitialViewController
    
    func updateActivityLabel(#text: String) {
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.activityLabel.text = text
        })
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    // MARK: Actions

    @IBAction func sendButtonPressed(sender: AnyObject) {
        self.username = self.messageTextField.text
        self.joinNetworkButton.enabled = true;

        self.updateActivityLabel(text: "Usename: \(self.username) has been setted")
    }
    
    @IBAction func joinNetworkButtonPressed(sender: AnyObject) {
        
        DANetwork.sharedInstance().subscribeUser(self.username!, toChannelWithName: "demo_tutorial") { (success: Bool, error: NSError?) -> Void in
            if (error != nil) {
                self.updateActivityLabel(text: PubNubHelper.ErrorMessages.errorSubscribing)
            } else {
                self.updateActivityLabel(text: PubNubHelper.ActivityMessages.subscriptionSuccefullyCompleted)
                // self.sendButton.enabled = true
                self.proceedToSampleAppButton.enabled = true
                
            }
        }
        
    
        /*
        var message = "JOIN_NETWORK_USERNAME:\(self.username!)"
        
        PubNubHelper.sharedInstance.sendMessage(message, channel: self.channel!, completionHandler: { (sucess, error) -> Void in
            if sucess {
                self.updateActivityLabel(text: "Initial identification achieved with usename: \(self.username!)")
                self.proceedToSampleAppButton.enabled = true
            }
            else {
                self.updateActivityLabel(text: PubNubHelper.ErrorMessages.errorSendingMessage)
            }
        })
        */
    }
    
    @IBAction func proceedToSampleAppButtonPressed(sender: AnyObject) {
        self.proceedToApplicationSpecificViewController()
    }
    
    
}
