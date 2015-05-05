//
//  UIViewControllerTransitions.swift
//  DANetworking
//
//  Created by Diomidis Papas on 05/05/2015.
//  Copyright (c) 2015 Diomidis Papas. All rights reserved.
//

import UIKit

extension UIViewController {
   
    func proceedToGroupViewController(#user: User) {
        let identifier = "GroupViewController"
        let controller: GroupViewController = self.storyboard!.instantiateViewControllerWithIdentifier(identifier) as! GroupViewController
        controller.user = user
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func proceedToRoomViewController(#user: User, room: Room) {
        let identifier = "RoomViewController"
        let controller: RoomViewController = self.storyboard!.instantiateViewControllerWithIdentifier(identifier) as! RoomViewController
        controller.user = user
        controller.room = room
        self.navigationController?.pushViewController(controller, animated: true)
    }

    
}

