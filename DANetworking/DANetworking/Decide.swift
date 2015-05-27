//
//  Decide.swift
//  DANetworking
//
//  Created by Diomidis Papas on 13/05/2015.
//  Copyright (c) 2015 Diomidis Papas. All rights reserved.
//


@objc (Decide)
class Decide: NSObject, DecideProtocol {
    var components: [Component]?
    var tasks: [Task]?
    var delegate: DecideProtocol?
    
    init(components: [Component], tasks: [Task]) {
        self.components! = components
        self.tasks! = tasks
        super.init()
    }
    
    
    // MARK : DecideProtocol Delegate
    
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
