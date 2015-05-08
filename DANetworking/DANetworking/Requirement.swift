//
//  Requirement.swift
//  DANetworking
//
//  Created by Diomidis Papas on 07/05/2015.
//  Copyright (c) 2015 Diomidis Papas. All rights reserved.
//

import UIKit

class Requirement<T>: NSObject {
    let cost: T
    
    init(cost: T) {
        self.cost = cost
        super.init()
    }
}
