//
//  Room.swift
//  DANetworking
//
//  Created by Diomidis Papas on 05/05/2015.
//  Copyright (c) 2015 Diomidis Papas. All rights reserved.
//

import UIKit

class Room: NSObject {
    var roomAlias: String?
    var roomId: String?
    
    init(dictionary: [String : AnyObject]) {
        var roomAlias = dictionary[Service.JSONResponseKeys.RoomAlias] as? String
        if let roomAlias = roomAlias {
            self.roomAlias = dictionary[Service.JSONResponseKeys.RoomAlias] as? String
        } else {
            self.roomAlias = "Unnamed Room"
        }
        roomId = dictionary[Service.JSONResponseKeys.RoomId] as? String
        super.init()
    }
}
