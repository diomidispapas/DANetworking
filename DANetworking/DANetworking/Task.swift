//
//  Task.swift
//  DANetworking
//
//  Created by Diomidis Papas on 07/05/2015.
//  Copyright (c) 2015 Diomidis Papas. All rights reserved.
//

import UIKit

class Task<T>: NSObject {
    let requirement: Requirement<T>
    let name: String
    
    init(name: String, requirement: Requirement<T>) {
        self.name = name
        self.requirement = requirement
        super.init()
    }
}
