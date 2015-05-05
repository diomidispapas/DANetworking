//
//  ServiceConstants.swift
//  DANetworking
//
//  Created by Diomidis Papas on 05/05/2015.
//  Copyright (c) 2015 Diomidis Papas. All rights reserved.
//

import Foundation

extension Service {
    
    // MARK: - Constants
    struct Constants {
        // MARK: API Key
        static let ApiKey : String = "ENTER_YOUR_API_KEY_HERE"
        
        // MARK: URLs
        static let BaseURL : String = "http://localhost:8008"
    }
    
    
    // MARK: - Methods
    struct Methods {
        
        static let Register = "/_matrix/client/api/v1/register"
        static let Login = "/_matrix/client/api/v1/login"
        static let CreateRoom = "/_matrix/client/api/v1/createRoom"
        static let SendMessage = "/_matrix/client/api/v1/rooms/{room_id}/send/m.room.message"
        static let GettingLiveState = "/_matrix/client/api/v1/events"

    }
    
    
    // MARK: - Methods
    struct ParameterKeys {
    
        static let AccessToken = "access_token"
        static let UpdateParameter = "&from="
    }
    
    
    // MARK: - URL Keys
    struct URLKeys {
        
        static let RoomId = "room_id"
        
    }
    

    // MARK: - JSON Body Keys
    struct JSONBodyKeys {
        
        static let User = "user"
        static let Password = "password"
        static let RegisterType = "type"
        
        // MARK: - Create Room Keys

        static let RoomName = "room_alias_name"
        
        // MARK: - Message Send Keys

        static let MessageType = "msgtype"
        static let MessageBody = "body"

    }
    
    
    // MARK: - JSON Response Keys
    struct JSONResponseKeys {
        
        // MARK: User
        static let UserId = "user_id"
        static let HomeServer = "home_server"
        static let AccessToken = "access_token"
        
        // MARK: Room
        static let RoomId = "room_id"
        static let RoomAlias = "room_alias"
        
    }

}
