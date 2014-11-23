//
//  LKStatusItemManager.swift
//  FreeSpace
//
//  Created by Lukas Kollmer on 23/11/14.
//  Copyright (c) 2014 Lukas Kollmer. All rights reserved.
//

import Foundation
import Cocoa

protocol LKFreeSpaceStatusItemDelegate {
    func didClickInfoButton()
    func didClickSettingsButton()
    func didClickQuitButton()
}


class LKFreeSpaceStatusItem: NSObject {
    
    
    
    private var statusItemMenu = NSMenu()
    private var statusItem: NSStatusItem!
    
    private var infoItem: NSMenuItem!
    private var settingsItem: NSMenuItem!
    private var quitItem: NSMenuItem!
    
    private var timer: NSTimer?
    
    private let freeSpaceManager = LKFreeSpaceManager()
    
    var delegate: LKFreeSpaceStatusItemDelegate?
    
    
    override init() {
        super.init()
        
        self.statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1)
        
        self.statusItem.highlightMode = true
        self.statusItem.title = "Loading..."
        self.statusItem.enabled = true
        self.statusItem.toolTip = "FreeSpace"
        self.statusItem.target = self
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: Selector("timerhh"), userInfo: nil, repeats: true)
    
        
        
        self.infoItem = NSMenuItem(title: "Info", action: Selector("didClickInfoButton"), keyEquivalent: "")
        self.statusItemMenu.insertItem(self.infoItem, atIndex: 0)
        
        self.settingsItem = NSMenuItem(title: "Settings", action: Selector("didClickSettingsButton"), keyEquivalent: "")
        self.statusItemMenu.insertItem(self.settingsItem, atIndex: 1)
        
        self.quitItem = NSMenuItem(title: "Quit", action: Selector("didClickQuitButton"), keyEquivalent: "")
        self.statusItemMenu.insertItem(self.quitItem, atIndex: 2)
        
        self.statusItem.menu = self.statusItemMenu
        
        
        
    
    }
    
    
    func timerhh() {
        println("timer")
        self.statusItem.title = self.freeSpaceManager.freeSpaceAsString()
    }
    
    
}