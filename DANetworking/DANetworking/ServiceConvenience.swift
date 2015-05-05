//
//  ServiceConvenience.swift
//  DANetworking
//
//  Created by Diomidis Papas on 05/05/2015.
//  Copyright (c) 2015 Diomidis Papas. All rights reserved.
//

import Foundation

extension Service {
    
    // MARK: - POST Convenience Methods
    
    func register(user: String, password: String, completionHandler: (user: User?, error: NSError?) -> Void) {
        
        let parameters = ["":""]
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        //let parameters = [TMDBClient.ParameterKeys.SessionID : TMDBClient.sharedInstance().sessionID!]
        var mutableMethod : String = Methods.Register
        let jsonBody : [String:AnyObject] = [
            Service.JSONBodyKeys.User: user,
            Service.JSONBodyKeys.Password: password,
            Service.JSONBodyKeys.RegisterType: "m.login.password"
        ]
        
        /* 2. Make the request */
        let task = taskForPOSTMethod(mutableMethod, parameters: parameters, jsonBody: jsonBody) { JSONResult, error in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandler(user: nil, error: error)
            } else {
                print(JSONResult)
                let user: User = User(dictionary: JSONResult as! Dictionary)
                completionHandler(user: user, error: nil)
                /*
                if let results = JSONResult.valueForKey(TMDBClient.JSONResponseKeys.StatusCode) as? Int {
                    completionHandler(result: results, error: nil)
                } else {
                    completionHandler(result: nil, error: NSError(domain: "postToFavoritesList parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse postToFavoritesList"]))
                }
                */
            }
        }
    }
    
    func login(user: String, password: String, completionHandler: (user: User?, error: NSError?) -> Void) {
        
        let parameters = ["":""]
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        //let parameters = [TMDBClient.ParameterKeys.SessionID : TMDBClient.sharedInstance().sessionID!]
        var mutableMethod : String = Methods.Login
        let jsonBody : [String:AnyObject] = [
            Service.JSONBodyKeys.RegisterType: "m.login.password",
            Service.JSONBodyKeys.User: user,
            Service.JSONBodyKeys.Password: password
        ]
        
        /* 2. Make the request */
        let task = taskForPOSTMethod(mutableMethod, parameters: parameters, jsonBody: jsonBody) { JSONResult, error in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandler(user: nil, error: error)
            } else {
                print(JSONResult)
                let user: User = User(dictionary: JSONResult as! Dictionary)
                completionHandler(user: user, error: nil)
                /*
                if let results = JSONResult.valueForKey(TMDBClient.JSONResponseKeys.StatusCode) as? Int {
                completionHandler(result: results, error: nil)
                } else {
                completionHandler(result: nil, error: NSError(domain: "postToFavoritesList parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse postToFavoritesList"]))
                }
                */
            }
        }
    }
    
    func createRoom(user: User, completionHandler: (room: Room?, error: NSError?) -> Void) {
        let parameters = [Service.ParameterKeys.AccessToken:user.accessToken!]
        
        /* 1. Specify parameters, method (if has {key}), and HTTP body (if POST) */
        //let parameters = [TMDBClient.ParameterKeys.SessionID : TMDBClient.sharedInstance().sessionID!]
        var mutableMethod : String = Methods.CreateRoom
        let jsonBody : [String:AnyObject] = ["":""]
        
        /* 2. Make the request */
        let task = taskForPOSTMethod(mutableMethod, parameters: parameters, jsonBody: jsonBody) { JSONResult, error in
            
            /* 3. Send the desired value(s) to completion handler */
            if let error = error {
                completionHandler(room: nil, error: error)
            } else {
                print(JSONResult)
                let room: Room = Room(dictionary: JSONResult as! Dictionary)
                completionHandler(room: room, error: nil)
                /*
                if let results = JSONResult.valueForKey(TMDBClient.JSONResponseKeys.StatusCode) as? Int {
                completionHandler(result: results, error: nil)
                } else {
                completionHandler(result: nil, error: NSError(domain: "postToFavoritesList parsing", code: 0, userInfo: [NSLocalizedDescriptionKey: "Could not parse postToFavoritesList"]))
                }
                */
            }
        }

    }


}