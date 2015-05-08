//
//  Component.swift
//  DANetworking
//
//  Created by Diomidis Papas on 07/05/2015.
//  Copyright (c) 2015 Diomidis Papas. All rights reserved.
//

import UIKit

class Component<T>: NSObject, DecideProtocol {
    var name: String
    var power: T
    var tasks: [Task<T>]
    
    init(name: String, power: T) {
        self.name = name
        self.power = power
        self.tasks = [Task<T>]()
    }
    
    
    // MARK : - DecideProtocol Delegate
    func localCapabilityAnalysis() {
        
    }
    
    func receiveRemoteNodesCapabilities() {
        
    }
    
    func selectionOfLocalContribution() {
        
    }
    
   
    func executionOfControlLoop() {
        
    }
    
    func majorChange() {
        
    }

}
