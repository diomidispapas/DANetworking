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
    
    
    // MARK: Outlets
    
    @IBOutlet weak var activityLabel: UILabel!
    
    @IBOutlet weak var messageTextField: UITextField!
    
    @IBOutlet weak var sendButton: UIButton!
    
    //MARK: UIViewController lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Disable send button
        self.sendButton.enabled = false
        
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
        
        // Get the pubnub instance
        self.pubNub = PubNub.sharedInstance()
        
        // Add observer
        self.pubNub?.observationCenter.addMessageReceiveObserver(self, withBlock: { (message:PNMessage!) -> Void in
            if  (message != nil) {
                var messageString :String = message.message as! String
                self.updateActivityLabel(text:"Message received: " + messageString)
            }
        })
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
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
        var message = self.messageTextField.text
        
        PubNubHelper.sharedInstance.sendMessage(message, channel: self.channel!, completionHandler: { (sucess, error) -> Void in
            if sucess {
                self.updateActivityLabel(text: PubNubHelper.ActivityMessages.messageSuccefullySent)
            }
            else {
                self.updateActivityLabel(text: PubNubHelper.ErrorMessages.errorSendingMessage)
            }
        })
    }
}
