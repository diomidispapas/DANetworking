//
//  Task.swift
//  DANetworking
//
//  Created by Diomidis Papas on 07/05/2015.
//  Copyright (c) 2015 Diomidis Papas. All rights reserved.
//

import UIKit

class Task: NSObject {
    let requirement: Requirement
    let name: String
    
    init(name: String, requirement: Requirement) {
        self.name = name
        self.requirement = requirement
        super.init()
    }
}
