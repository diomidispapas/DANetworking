//
//  User.swift
//  DANetworking
//
//  Created by Diomidis Papas on 05/05/2015.
//  Copyright (c) 2015 Diomidis Papas. All rights reserved.
//

import UIKit

public class User: NSObject {
    var userId: String?
    var accessToken:String?
    var homeServer: String?
    
    init(dictionary: [String : AnyObject]) {
        userId = dictionary[Service.JSONResponseKeys.UserId] as? String
        accessToken = dictionary[Service.JSONResponseKeys.AccessToken] as? String
        homeServer = dictionary[Service.JSONResponseKeys.HomeServer] as? String
        super.init()
    }
}
