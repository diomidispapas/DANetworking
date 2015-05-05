//
//  ServiceTests.swift
//  DANetworking
//
//  Created by Diomidis Papas on 05/05/2015.
//  Copyright (c) 2015 Diomidis Papas. All rights reserved.
//

import UIKit
import XCTest

class ServiceTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func DISABLE_testRegister() {
        let expectation = expectationWithDescription("Register")

        Service.sharedInstance().register("Diomidis2", password: "1131990") { (user, error) -> Void in
            if let error = error {
                XCTAssert(false, "Failure")
            } else {
                print(user!)
                XCTAssert(true, "Pass")
            }
            expectation.fulfill()
        }
    
        waitForExpectationsWithTimeout(10, handler: { (error) -> Void in
        })
    }

    func DISABLE_testLogin() {
        // This is an example of a functional test case.
        let expectation = expectationWithDescription("Login")
        
        Service.sharedInstance().login("Diomidis", password: "1131990") { (user, error) -> Void in
            if let error = error {
                XCTAssert(user == nil, "failure")
            } else {
                print(user!)
                XCTAssert(true, "pass")
            }
            expectation.fulfill()

        }
        
        waitForExpectationsWithTimeout(10, handler: { (error) -> Void in
        })

    }
    
    func testRoomCreation() {
        // This is an example of a functional test case.
        let expectation = expectationWithDescription("Create Room")

        Service.sharedInstance().login("Diomidis", password: "1131990") { (user, error) -> Void in
            if let error = error {
            } else {
                if let user = user {
                    print(user)
                    
                    Service.sharedInstance().createRoom(user, roomName: "TestRoom") { (room, error) -> Void in
                        if let error = error {
                            XCTAssert(room == nil, "failure")
                        } else {
                            if let room = room {
                                print(room)
                                XCTAssert(true, "pass")
                            }
                        }
                        expectation.fulfill()
                    }

                }
            }
            
        }
        
        waitForExpectationsWithTimeout(10, handler: { (error) -> Void in
        })
        
    }

    
    func DISABLED_testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }

}
