//
//  RoomViewController.swift
//  DANetworking
//
//  Created by Diomidis Papas on 05/05/2015.
//  Copyright (c) 2015 Diomidis Papas. All rights reserved.
//

import UIKit

class RoomViewController: UIViewController {
    var user: User? = nil
    var room: Room? = nil
    
    
    @IBOutlet weak var statusLabel: UILabel!
    
    // MARK: - Lifecycle

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)

        self.statusLabel.text = "Welcome to \(room!.roomAlias!)"
        self.getLiveState()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions

    @IBAction func inviteFriendsButtonPressed(sender: AnyObject) {
    }
    
    @IBAction func sendSampleMessageButtonPressed(sender: AnyObject) {
        self.sendSampleMessage()
    }
    
    
    // MARK: - RoomViewController

    func sendSampleMessage(){
        Service.sharedInstance().sendMessage(user!, room: room!, message: "Test message ;)") { (success, error) -> Void in
            if success {
                self.completeSampleMessage()
            }
        }
    }

    func completeSampleMessage() {
        dispatch_async(dispatch_get_main_queue(), {
            if let user = self.user {
                self.statusLabel.text = "Message sent successfully"
            }
        })
    }
    
    func getLiveState() {
        Service.sharedInstance().getLiveState(user!, completionHandler: { (success, error) -> Void in
            if success {
                dispatch_async(dispatch_get_main_queue(), {
                    if let user = self.user {
                        self.statusLabel.text = "Status updated"
                    }
                })
            }
            if let error = error {
                self.displayError("Coudnt get live state of the group/")
            }
        })
    }
    
    func updateStatus() {
        Service.sharedInstance().updateState(self.user, from: <#String#>, completionHandler: { (success, error) -> Void in
            
        })
    }
    
    // MARK: - Helpers
    
    func displayError(errorString: String?) {
        dispatch_async(dispatch_get_main_queue(), {
            if let errorString = errorString {
                self.statusLabel.text = errorString
            }
        })
    }
}

