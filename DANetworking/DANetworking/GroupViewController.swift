//
//  GroupViewController.swift
//  DANetworking
//
//  Created by Diomidis Papas on 05/05/2015.
//  Copyright (c) 2015 Diomidis Papas. All rights reserved.
//

import UIKit

class GroupViewController: UIViewController {
    var user: User? = nil
    var room: Room? = nil
    
    // MARK - Outlets
    
    @IBOutlet weak var createGroupButton: UIButton!
    @IBOutlet weak var goToRoomButton: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.goToRoomButton.hidden = true
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    
    // MARK: - Actions

    @IBAction func createGroupButtonPressed(sender: AnyObject) {
        if let user = self.user {
            self.createRoom(user)
        }
    }
    
    @IBAction func goToRoomButtonPressed(sender: AnyObject) {
        self.proceedToRoomViewController(user: self.user!, room: self.room!)
    }
    
    // MARK: - GroupViewController

    func createRoom(user: User) {
        Service.sharedInstance().createRoom(user, roomName: "testRoom", completionHandler: { (room, error) -> Void in
            if let error = error {
                self.displayError("Error creating room")
            }
            if let room = room {
                self.room = room
                self.completeRoomCreation()
            }
        })
    }
    
    func completeRoomCreation() {
        dispatch_async(dispatch_get_main_queue(), {
            if let user = self.user {
                self.statusLabel.text = "Room created for \(user.userId!) with roomId: \(self.room!.roomId!) and alias \(self.room!.roomAlias!)"
                self.goToRoomButton.hidden = false
                self.createGroupButton.hidden = true
            }
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
