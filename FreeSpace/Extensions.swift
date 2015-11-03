//
//  Extensions.swift
//  FreeSpace
//
//  Created by Lukas Kollmer on 07/12/14.
//  Copyright (c) 2014 Lukas Kollmer. All rights reserved.
//

import Foundation
import Cocoa

typealias LKNotificationLevel = Int

extension NSMatrix {
    
    
    var selectedFileUnit: FileUnit {
        get {
            if self.selectedRow == 0 {
                return FileUnit.Automatic
            } else {
                return FileUnit.GB
            }
        }
    }
}


extension NSApplication {
    
    var isLaunchItem: Bool {
        get {
            return self.applicationIsInStartUpItems()
        }
    }
    
    func addToLaunchItems() {
        if self.isLaunchItem {
            return
        } else {
            self.enableLaunchAtLogin()
        }
    }
    
    
    func removeFromLaunchItems() {
        if !self.isLaunchItem {
            return
        } else {
            self.disableLaunchAtLogin()
        }
    }
    
    // MARK: Startup stuff
    private func applicationIsInStartUpItems() -> Bool {
        return (itemReferencesInLoginItems().existingReference != nil)
    }
    
    private func itemReferencesInLoginItems() -> (existingReference: LSSharedFileListItemRef?, lastReference: LSSharedFileListItemRef?) {
        let itemUrl : UnsafeMutablePointer<Unmanaged<CFURL>?> = UnsafeMutablePointer<Unmanaged<CFURL>?>.alloc(1)
        if let appUrl : NSURL = NSURL.fileURLWithPath(NSBundle.mainBundle().bundlePath) {
            let loginItemsRef = LSSharedFileListCreate(
                nil,
                kLSSharedFileListSessionLoginItems.takeRetainedValue(),
                nil
                ).takeRetainedValue() as LSSharedFileListRef?
            if loginItemsRef != nil {
                let loginItems: NSArray = LSSharedFileListCopySnapshot(loginItemsRef, nil).takeRetainedValue() as NSArray
                print("There are \(loginItems.count) login items")
                let lastItemRef: LSSharedFileListItemRef = loginItems.lastObject as! LSSharedFileListItemRef
                for var i = 0; i < loginItems.count; ++i {
                    let currentItemRef: LSSharedFileListItemRef = loginItems.objectAtIndex(i) as! LSSharedFileListItemRef
                    if LSSharedFileListItemResolve(currentItemRef, 0, itemUrl, nil) == noErr {
                        if let urlRef: NSURL =  itemUrl.memory?.takeRetainedValue() {
                            print("URL Ref: \(urlRef.lastPathComponent)")
                            if urlRef.isEqual(appUrl) {
                                return (currentItemRef, lastItemRef)
                            }
                        }
                    } else {
                        print("Unknown login application")
                    }
                }
                //The application was not found in the startup list
                return (nil, lastItemRef)
            }
        }
        return (nil, nil)
    }
    
    private func enableLaunchAtLogin() {
        let itemReferences = itemReferencesInLoginItems()
        let loginItemsRef = LSSharedFileListCreate(
            nil,
            kLSSharedFileListSessionLoginItems.takeRetainedValue(),
            nil
            ).takeRetainedValue() as LSSharedFileListRef?
        if loginItemsRef != nil {
            if let appUrl : CFURLRef = NSURL.fileURLWithPath(NSBundle.mainBundle().bundlePath) {
                LSSharedFileListInsertItemURL(
                    loginItemsRef,
                    itemReferences.lastReference,
                    nil,
                    nil,
                    appUrl,
                    nil,
                    nil
                )
                print("Application was added to login items")
            }
        }
        
    }
    
    
    private func disableLaunchAtLogin() {
        let itemReferences = itemReferencesInLoginItems()
        let loginItemsRef = LSSharedFileListCreate(
            nil,
            kLSSharedFileListSessionLoginItems.takeRetainedValue(),
            nil
            ).takeRetainedValue() as LSSharedFileListRef?
        if loginItemsRef != nil {
            if let itemRef = itemReferences.existingReference {
                LSSharedFileListItemRemove(loginItemsRef,itemRef);
                print("Application was removed from login items")
            }
        }
    }
    
    
    
}