//
//  MXService.swift
//  DANetworking
//
//  Created by Diomidis Papas on 06/05/2015.
//  Copyright (c) 2015 Diomidis Papas. All rights reserved.
//

import UIKit

class MXService: NSObject {
    
    // MARK: - Shared Instance

    class func sharedInstance() -> MXService {
        
        struct Singleton {
            static var sharedInstance = MXService()
        }
        
        return Singleton.sharedInstance
    }

    
    // MARK: Rooms
    
    func getPublicRooms(completionHandler: (rooms: [MXRoom]!, error: NSError?) -> Void) {
        var mxClient: MXRestClient = MXRestClient(homeServer: Service.Constants.BaseURL)
        mxClient.publicRooms({ (rooms) -> Void in
            println("Rooms: \(rooms)")
            if let rooms = rooms {
                completionHandler(rooms: rooms as! [MXRoom], error: nil)
            }
        }, failure: { (error) -> Void in
            println("Something went wrong getting rooms")
            completionHandler(rooms: nil,error: nil)
        })
        
    }
    
    func joinToRoom(#name: String) {
        
    }
    
    func getMxSession(user: User, roomId: String, completionHandler: (mxSession: MXSession?, error: NSError?) -> Void) {
        
        var credentials: MXCredentials = MXCredentials(homeServer: Service.Constants.BaseURL, userId: user.userId, accessToken: user.accessToken)
        // Create a matrix session
        var mxRestClient: MXRestClient = MXRestClient(credentials: credentials)
        
        // Create a matrix session
        var mxSession: MXSession = MXSession(matrixRestClient: mxRestClient)
        mxSession.start({ () -> Void in
            mxSession.rooms()
            completionHandler(mxSession: mxSession,error: nil)
            }, failure: { (error: NSError?) -> Void in
            completionHandler(mxSession: nil,error: error)
        })

    }
    
    func getMessagesOfRoom(mxSession: MXSession, roomId: String, completionHandler: (endParameter: String, error: NSError?) -> Void) {
        var room : MXRoom = MXRoom(roomId: roomId, andMatrixSession: mxSession)
        
        room.listenToEvents { (event: MXEvent!, direction: MXEventDirection, roomState:MXRoomState!) -> Void in
            println("An event woke me up")
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
        }
    }
}
