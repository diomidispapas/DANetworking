//
//  Component.swift
//  DANetworking
//
//  Created by Diomidis Papas on 07/05/2015.
//  Copyright (c) 2015 Diomidis Papas. All rights reserved.
//

import UIKit

@objc (Component)
class Component: NSObject, DecideProtocol {
    var name: String
    var power: Double
    var tasks: [Task]
    
    init(name: String, power: Double) {
        self.name = name
        self.power = power
        self.tasks = [Task]()
        super.init()
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
