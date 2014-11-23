//
//  AppDelegate.swift
//  FreeSpace
//
//  Created by Lukas Kollmer on 23/11/14.
//  Copyright (c) 2014 Lukas Kollmer. All rights reserved.
//

import Foundation
import Cocoa
//import CoreData

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, LKFreeSpaceStatusItemDelegate {

    //@IBOutlet weak var window: NSWindow!
    //@IBOutlet weak var menu: NSMenu!
    
    var freeSpaceStatusItem: LKFreeSpaceStatusItem!
    var window: NSWindowController?

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        
        self.freeSpaceStatusItem = LKFreeSpaceStatusItem()
        
        
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }

    
    func didClickInfoButton() {
        println("didClickInfoButton")
    }
    
    func didClickSettingsButton() {
        println("didClickSettingsButton")
        self.window = NSWindowController(windowNibName: "LKMainWindow")
        /*
        self.window?.window?.makeMainWindow()
        self.window?.window?.makeKeyWindow()
        self.window?.window?.becomeKeyWindow()
        self.window?.window?.becomeMainWindow()
*/
        self.window?.showWindow(self)
        self.window?.window?.makeKeyAndOrderFront(nil)
        println(self.window?.window)
        NSApp.activateIgnoringOtherApps(true)
        
    }
    
    func didClickQuitButton() {
        println("didClickQuitButton")
        self.window = NSWindowController(windowNibName: "LKMainWindow")
        
        self.window?.showWindow(self)
        self.window?.window?.makeKeyAndOrderFront(nil)
        NSApp.activateIgnoringOtherApps(true)

    }


}

