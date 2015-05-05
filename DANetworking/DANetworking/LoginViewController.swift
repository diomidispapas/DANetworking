//
//  LoginViewController.swift
//  DANetworking
//
//  Created by Diomidis Papas on 05/05/2015.
//  Copyright (c) 2015 Diomidis Papas. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    var user: User? = nil

    // MARK - Outlets
    
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.statusLabel.text = "Fill the textfields and press log in button"

    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
    }
    
    // MARK: - Actions

    @IBAction func loginButtonPressed(sender: AnyObject) {
        self.login()
    }
    
    // MARK: - LoginViewController
    
    func login() {
        let username = self.usernameTextField.text
        let password = self.passwordTextField.text
        
        Service.sharedInstance().login(username, password: password) { (user, error) -> Void in
            if let user = user {
                self.user = user
                self.completeLogin()
            }
            if let error = error {
                self.displayError("Something went wrong during the login process")
            }
        }

    }

    func completeLogin() {
        dispatch_async(dispatch_get_main_queue(), {
            if let user = self.user {
                self.statusLabel.text = "User \(user.userId!) logged in successfully"
                
                // Proceed to the next controller
                self.proceedToGroupViewController(user: user)
            }
        })
    }
    
        
    func displayError(errorString: String?) {
        dispatch_async(dispatch_get_main_queue(), {
            if let errorString = errorString {
                self.statusLabel.text = errorString
            }
        })
    }

    
}
