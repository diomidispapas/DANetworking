//
//  Requirement.swift
//  DANetworking
//
//  Created by Diomidis Papas on 07/05/2015.
//  Copyright (c) 2015 Diomidis Papas. All rights reserved.
//

import UIKit

@objc (Requirement)
class Requirement: NSObject {
    let cost: Double
    
    init(cost: Double) {
        self.cost = cost
        super.init()
    }
}
