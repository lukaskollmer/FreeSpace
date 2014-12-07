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
class AppDelegate: NSObject, NSApplicationDelegate {

    //@IBOutlet weak var window: NSWindow!
    //@IBOutlet weak var menu: NSMenu!
    
    var freeSpaceStatusItem: LKFreeSpaceStatusItem!
    var window: NSWindowController?

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        
        self.freeSpaceStatusItem = LKFreeSpaceStatusItem()
        self.freeSpaceStatusItem.infoButtonClicked = {(infoButton: NSMenuItem?) in
            println("info buttonclicked in closure. InfoButton: \(infoButton)")
            
        }
        
        self.freeSpaceStatusItem.settingsButtonClicked = {(settingsButton: NSMenuItem?) in
            println("settings buttonclicked in closure. settingsButton: \(settingsButton)")
            self.window = NSWindowController(windowNibName: "LKMainWindow")
            
            self.window?.showWindow(self)
            self.window?.window?.makeKeyAndOrderFront(nil)
            println(self.window?.window)
            NSApp.activateIgnoringOtherApps(true)
        }
        
        self.freeSpaceStatusItem.quitButtonClicked = {(quitButton: NSMenuItem?) in
            println("quit buttonclicked in closure. quitButton: \(quitButton)")
            NSApplication.sharedApplication().terminate(self)
        }
        
        
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }



}

