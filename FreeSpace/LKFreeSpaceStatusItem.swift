//
//  LKStatusItemManager.swift
//  FreeSpace
//
//  Created by Lukas Kollmer on 23/11/14.
//  Copyright (c) 2014 Lukas Kollmer. All rights reserved.
//

import Foundation
import Cocoa


class LKFreeSpaceStatusItem: NSObject {
    
    
    var shouldDisplayNotification = true
    
    private var statusItemMenu = NSMenu()
    private var statusItem: NSStatusItem!
    
    private var infoItem: NSMenuItem!
    private var settingsItem: NSMenuItem!
    private var quitItem: NSMenuItem!
    
    private var timer: NSTimer?
    private let metadataQuery = NSMetadataQuery()
    
    private let freeSpaceManager = LKFreeSpaceManager(notificationLevels: nil)
    
    var infoButtonClicked: ((infoButton: NSMenuItem?) -> Void)?
    var settingsButtonClicked: ((settingsButton: NSMenuItem?) -> Void)?
    var quitButtonClicked: ((quitButton: NSMenuItem?) -> Void)?
    
    
    
    
    override init() {
        super.init()
        
        self.statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(-1)
        
        self.statusItem.highlightMode = true
        self.statusItem.title = "Loading..."
        self.statusItem.enabled = true
        self.statusItem.toolTip = "FreeSpace"
        self.statusItem.target = self
        
        //self.timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: Selector("timerhh"), userInfo: nil, repeats: true)
    
        
        
        self.infoItem = NSMenuItem(title: "Info", action: Selector("didClickInfoButton"), keyEquivalent: "")
        self.infoItem.target = self
        self.statusItemMenu.insertItem(self.infoItem, atIndex: 0)
        
        self.settingsItem = NSMenuItem(title: "Settings", action: Selector("didClickSettingsButton"), keyEquivalent: ",")
        self.settingsItem.target = self
        self.statusItemMenu.insertItem(self.settingsItem, atIndex: 1)
        
        self.quitItem = NSMenuItem(title: "Quit", action: Selector("didClickQuitButton"), keyEquivalent: "q")
        self.quitItem.target = self
        self.statusItemMenu.insertItem(self.quitItem, atIndex: 2)
        
        self.statusItem.menu = self.statusItemMenu
        
        self.updateStatusItemTitle()
        
        self.startWatching()
        
        
        NSTimer.every(30*60) { () -> Void in
            self.shouldDisplayNotification = true
        }
        
        
        
    
    }
    
    func startWatching() {
        self.metadataQuery.searchScopes = ["/"]
        self.metadataQuery.predicate = NSPredicate(format: "%K like '*.*'", NSMetadataItemFSNameKey)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("queryFoundStuff:"), name: NSMetadataQueryDidFinishGatheringNotification, object: self.metadataQuery)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("queryFoundStuff:"), name: NSMetadataQueryDidUpdateNotification, object: self.metadataQuery)
        
        self.metadataQuery.startQuery()
    }
    
    func setFileSizeUnit(newUnit: FileUnit) {
        print("in lkfreespaceitem setfilesize funcstion")
        self.freeSpaceManager.setUnit(newUnit, completionHandler: {() in
            self.updateStatusItemTitle()
        })
    }
    
    func queryFoundStuff(sender: AnyObject) {
        print("queryFoundStuff:")
        self.updateStatusItemTitle()
        self.checkIfNotificationIsNeccessary()
    }
    
    func updateStatusItemTitle() {
        self.statusItem.title = self.freeSpaceManager.freeSpaceAsString()
    }
    
    
    func checkIfNotificationIsNeccessary() {
        var spaceString = self.freeSpaceManager.freeSpaceAsString()
        spaceString.removeFileSizeTextAndConvertCommasToPoints()
        
        var totalSpace = self.freeSpaceManager.totalSpaceAsString()
        totalSpace.removeFileSizeTextAndConvertCommasToPoints()

        let freeSpaceAsDouble  = Double(spaceString)
        let totalSpaceAsDouble = Double(totalSpace)
        print(0.1 * totalSpaceAsDouble!)
        
        if freeSpaceAsDouble < (0.1 * totalSpaceAsDouble!) {
            showNotification()
        }
    }
    
    func showNotification() {
        if shouldDisplayNotification {
            let notification = NSUserNotification()
            notification.title = "Running low on space"
            notification.informativeText = "You have less that 10 % free space left"
            NSUserNotificationCenter.defaultUserNotificationCenter().deliverNotification(notification)
        }
        
        shouldDisplayNotification = false
    }
    
    func didClickInfoButton() {
        self.infoButtonClicked?(infoButton: self.infoItem)
    }
    
    func didClickSettingsButton() {
        self.settingsButtonClicked?(settingsButton: self.settingsItem)
        
    }
    
    func didClickQuitButton() {
        self.quitButtonClicked?(quitButton: self.quitItem)
    }

    
}


extension String {
    mutating func removeFileSizeTextAndConvertCommasToPoints() {
        self = self.stringByReplacingOccurrencesOfString(" GB", withString: "")
            .stringByReplacingOccurrencesOfString(" MB", withString: "")
            .stringByReplacingOccurrencesOfString(" KB", withString: "")
            .stringByReplacingOccurrencesOfString(",", withString: ".")
        
    }
}