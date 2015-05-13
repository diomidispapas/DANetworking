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
    var mxRoom: MXRoom? = nil
    
    
    @IBOutlet weak var statusLabel: UILabel!
    
    // MARK: - Lifecycle

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)

        self.statusLabel.text = "Welcome to \(room!.roomAlias!)"
        // self.getLiveState()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        
        if let mxRoom = self.mxRoom {
            mxRoom.removeAllListeners()
        }
        
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
    /*
    func getLiveState() {
        MXService.sharedInstance().getMxSession(user!, roomId: self.room!.roomId!) {[unowned self] (mxSession, error) -> Void in
            if let mxSession = mxSession {
                /*
                MXService.sharedInstance().getMessagesOfRoom(mxSession, roomId: self.room!.roomId!, completionHandler: { (endParameter, error) -> Void in
                    
                })
                */
                var room : MXRoom = MXRoom(roomId: self.room!.roomId!, andMatrixSession: mxSession)
                
                self.mxRoom = room
                /*
                var mxMembersEvents = [
                kMXEventTypeStringRoomMember,
                kMXEventTypeStringRoomPowerLevels,
                kMXEventTypeStringPresence,
                kMXEventTypeStringRoomMessage
                ]
                
                self.mxRoom!.listenToEventsOfTypes(mxMembersEvents as [AnyObject], onEvent: { (event: MXEvent!, direction: MXEventDirection, roomState:MXRoomState!) -> Void in
                    
                    println("An event woke me up")
                    println(event)
                    room.handleLiveEvent(event)

                    switch direction.value {
                    case MXEventDirectionForwards.value:
                        // Live/New events come here
                        println(event)
                    case MXEventDirectionBackwards.value:
                        // Events that occured in the past will come here when requesting pagination.
                        // roomState contains the state of the room just before this event occured.
                        println(event)
                    default:
                        println(event)
                        
                    }
                })
                */

                room.listenToEvents { (event: MXEvent!, direction: MXEventDirection, roomState:MXRoomState!) -> Void in
                    
   //                 dispatch_async(dispatch_get_main_queue(), {
                    if ((event) != nil) {
                        dispatch_async(dispatch_get_main_queue(), { () -> Void in
                            println("An event woke me up")
                            println(event)
                        })
                    }

                    switch direction.value {
                    case MXEventDirectionForwards.value:
                        // Live/New events come here
                        println(event)
                    case MXEventDirectionBackwards.value:
                        // Events that occured in the past will come here when requesting pagination.
                        // roomState contains the state of the room just before this event occured.
                        println(event)
                    case MXEventDirectionSync.value:
                        println(event)
                    default:
                        println(event)
                        }
              //      })
                }
            }
            if let error = error {
                self.displayError("Error getting Matrix Session")
            }
        }
    }
    */
    /*
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
    */
    // MARK: - Helpers
    
    func displayError(errorString: String?) {
        dispatch_async(dispatch_get_main_queue(), {
            if let errorString = errorString {
                self.statusLabel.text = errorString
            }
        })
    }
}

