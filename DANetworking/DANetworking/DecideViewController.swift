//
//  DecideViewController.swift
//  DANetworking
//
//  Created by Diomidis Papas on 07/05/2015.
//  Copyright (c) 2015 Diomidis Papas. All rights reserved.
//

import UIKit

class DecideViewController: UIViewController {
    var tasks: [Task]?
    var components: [Component]?
    
    // MARK - Outlets

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        createTasks()
        createComponents()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - DecideViewController
    
    func createTasks() {
        var requirementsA = Requirement(cost: 5.0)
        var taskA = Task(name: "A", requirement: requirementsA)
        
        var requirementsB = Requirement(cost: 4.0)
        var taskB = Task(name: "B", requirement: requirementsB)
        
        var requirementsC = Requirement(cost: 3.0)
        var taskC = Task(name: "C", requirement: requirementsC)
       
        tasks = [Task]()
        tasks?.append(taskA)
        tasks?.append(taskB)
        tasks?.append(taskC)
        
        println("Tasks added")
    }
    
    func createComponents() {
        var componentA = Component(name: "MacBook", power: 10)
        var componentB = Component(name: "PC", power: 8)
        var componentC = Component(name: "Tablet", power: 6)

        components = [Component]()
        components?.append(componentA)
        components?.append(componentB)
        components?.append(componentC)
        
        println("Components added")
    }
    
    
}
