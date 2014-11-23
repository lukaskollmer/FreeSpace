//
//  FreeSpaceTests.swift
//  FreeSpaceTests
//
//  Created by Lukas Kollmer on 23/11/14.
//  Copyright (c) 2014 Lukas Kollmer. All rights reserved.
//

import Cocoa
import XCTest

class FreeSpaceTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        XCTAssert(true, "Pass")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testLoadingWindow1() {
        self.measureBlock() {
            
            let window = NSWindowController(windowNibName: "LKMainWindow")
            
            window.window?.makeMainWindow()
            window.window?.makeKeyWindow()
            window.window?.becomeKeyWindow()
            window.window?.becomeMainWindow()
            
            window.showWindow(self)
            NSApp.activateIgnoringOtherApps(true)
        }
    }
    
    func testLoadingWindow2() {
        self.measureBlock() {
            
            let window = NSWindowController(windowNibName: "LKMainWindow")

            window.showWindow(self)
            window.window?.makeKeyAndOrderFront(nil)
            NSApp.activateIgnoringOtherApps(true)
        }
    }
    
}
