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
        roomAlias = dictionary[Service.JSONResponseKeys.RoomAlias] as? String
        roomId = dictionary[Service.JSONResponseKeys.RoomId] as? String
        super.init()
    }
}
