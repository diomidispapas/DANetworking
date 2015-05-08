//
//  DecideViewController.swift
//  DANetworking
//
//  Created by Diomidis Papas on 07/05/2015.
//  Copyright (c) 2015 Diomidis Papas. All rights reserved.
//

import UIKit

class DecideViewController: UIViewController {
    var tasks: [Task<Double>]?
    var components: [Component<Double>]?
    
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
        var requirementsA = Requirement<Double>(cost: 5.0)
        var taskA = Task<Double>(name: "A", requirement: requirementsA)
        
        var requirementsB = Requirement<Double>(cost: 4.0)
        var taskB = Task<Double>(name: "B", requirement: requirementsB)
        
        var requirementsC = Requirement<Double>(cost: 3.0)
        var taskC = Task<Double>(name: "C", requirement: requirementsC)
       
        tasks = [Task]()
        tasks?.append(taskA)
        tasks?.append(taskB)
        tasks?.append(taskC)
        
        println("Tasks added")
    }
    
    func createComponents() {
        var componentA = Component<Double>(name: "MacBook", power: 10)
        var componentB = Component<Double>(name: "PC", power: 8)
        var componentC = Component<Double>(name: "Tablet", power: 6)

        components = [Component]()
        components?.append(componentA)
        components?.append(componentB)
        components?.append(componentC)
        
        println("Components added")
    }
    
    
}
