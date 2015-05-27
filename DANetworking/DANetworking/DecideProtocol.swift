//
//  DecideProtocol.swift
//  DANetworking
//
//  Created by Diomidis Papas on 07/05/2015.
//  Copyright (c) 2015 Diomidis Papas. All rights reserved.
//

import Foundation

@objc (DecideProtocol)
protocol DecideProtocol {

    /**
    * This stage is executed infrequently (e.g., when the component joins the system)
    */
    func localCapabilityAnalysis()
    
    /**
    * The capability summary is shared with the peer components
    */
    func receiveRemoteNodesCapabilities()
    
    /**
    * This stage is executed infrequently (e.g., when the component joins the system)
    */
    func selectionOfLocalContribution();
    
    /**
    * Most of the time, the execution of a local control loop is the only DECIDE stage carried out by a component.
    */
    func executionOfControlLoop();
    
    /**
    * Infrequently, events such as signifi- cant workload increases or failures of component parts render a DECIDE local control loop unable to achieve its CLA.
    */
    func majorChange();

}
