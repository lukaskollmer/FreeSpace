//
//  LKMainWindow.swift
//  FreeSpace
//
//  Created by Lukas Kollmer on 23/11/14.
//  Copyright (c) 2014 Lukas Kollmer. All rights reserved.
//

import Cocoa

public enum FileUnit: Int {
    case Automatic = 0
    case GB = 1
    
    init(int: Int) {
        switch int {
        case 0:
            self = .Automatic
            break
        case 1:
            self = .GB
            break
        default:
            self = .Automatic
            break
        }
    }
}

class LKMainWindow: NSWindowController, NSWindowDelegate {
    
    @IBOutlet weak var launchAtLoginButton: NSButton!
    
    @IBOutlet weak var fileSizeUnitRadioButton: NSMatrix!
    
    @IBOutlet weak var showNotificationsButton: NSButton!
    
    @IBOutlet weak var notifyAt2GbButton: NSButton!
    
    @IBOutlet weak var notifyAt5GbButton: NSButton!
    
    @IBOutlet weak var notifyAt10GbButton: NSButton!
    
    @IBOutlet weak var notifyAt15GbButton: NSButton!
    
    @IBOutlet weak var notifyAt25GbButton: NSButton!
    
    @IBOutlet weak var notifyAt50GbButton: NSButton!
    
    
    
    
    var fileUnitChangeHandler: ((unit: FileUnit) -> Void)?
    
    
    
    override init() {
        super.init(window: nil)
        
        /* Load window from xib file */
        println("****")
        NSBundle.mainBundle().loadNibNamed("LKMainWindow", owner: self, topLevelObjects: nil)
        self.window?.makeKeyAndOrderFront(self)
        self.showWindow(self.window)
        self.window?.delegate = self
        NSApp.activateIgnoringOtherApps(true)
        //super.init(window: self.window)
        self.loadWindow()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if !NSApplication.sharedApplication().isLaunchItem {
            self.launchAtLoginButton.state = 0
        }
        
        let fileUnit: FileUnit = FileUnit(int: NSUserDefaults.standardUserDefaults().integerForKey("fileUnit"))
        
        self.fileSizeUnitRadioButton.selectCellAtRow(fileUnit.rawValue, column: 0)
        
        
        
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()

        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        println("windowDidLoad")
    }
    
    
    @IBAction func settingsChanged(sender: AnyObject) {
        println("settins changed")
        
        switch sender {
        case self.launchAtLoginButton as NSButton:
            self.updateLaunchAtLoginSettings()
            break
        case self.fileSizeUnitRadioButton as NSMatrix:
            self.updateFileSizeSettings()
            break
        case self.showNotificationsButton as NSButton, self.notifyAt2GbButton as NSButton, self.notifyAt5GbButton as NSButton, self.notifyAt10GbButton as NSButton, self.notifyAt15GbButton as NSButton, self.notifyAt25GbButton as NSButton, self.notifyAt50GbButton as NSButton:
            break
        default:
            break
        }
    }
    
    func updateLaunchAtLoginSettings() {
        if NSApplication.sharedApplication().isLaunchItem {
            self.launchAtLoginButton.state = 0
            NSApplication.sharedApplication().removeFromLaunchItems()
        } else {
            self.launchAtLoginButton.state = 1
            NSApplication.sharedApplication().addToLaunchItems()
        }
    }
    
    
    func updateFileSizeSettings() {
        let fileUnit = self.fileSizeUnitRadioButton.selectedFileUnit
        
        NSUserDefaults.standardUserDefaults().setInteger(fileUnit.rawValue, forKey: "fileUnit")
        
        self.fileUnitChangeHandler?(unit: fileUnit)
    }
    
    
    func updateNotificationSettings() {
        
    }
    
    
}

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
        var itemUrl : UnsafeMutablePointer<Unmanaged<CFURL>?> = UnsafeMutablePointer<Unmanaged<CFURL>?>.alloc(1)
        if let appUrl : NSURL = NSURL.fileURLWithPath(NSBundle.mainBundle().bundlePath) {
            let loginItemsRef = LSSharedFileListCreate(
                nil,
                kLSSharedFileListSessionLoginItems.takeRetainedValue(),
                nil
                ).takeRetainedValue() as LSSharedFileListRef?
            if loginItemsRef != nil {
                let loginItems: NSArray = LSSharedFileListCopySnapshot(loginItemsRef, nil).takeRetainedValue() as NSArray
                println("There are \(loginItems.count) login items")
                let lastItemRef: LSSharedFileListItemRef = loginItems.lastObject as LSSharedFileListItemRef
                for var i = 0; i < loginItems.count; ++i {
                    let currentItemRef: LSSharedFileListItemRef = loginItems.objectAtIndex(i) as LSSharedFileListItemRef
                    if LSSharedFileListItemResolve(currentItemRef, 0, itemUrl, nil) == noErr {
                        if let urlRef: NSURL =  itemUrl.memory?.takeRetainedValue() {
                            println("URL Ref: \(urlRef.lastPathComponent)")
                            if urlRef.isEqual(appUrl) {
                                return (currentItemRef, lastItemRef)
                            }
                        }
                    } else {
                        println("Unknown login application")
                    }
                }
                //The application was not found in the startup list
                return (nil, lastItemRef)
            }
        }
        return (nil, nil)
    }
    /*
    private func toggleLaunchAtStartup() {
        let itemReferences = itemReferencesInLoginItems()
        let shouldBeToggled = (itemReferences.existingReference == nil)
        let loginItemsRef = LSSharedFileListCreate(
            nil,
            kLSSharedFileListSessionLoginItems.takeRetainedValue(),
            nil
            ).takeRetainedValue() as LSSharedFileListRef?
        if loginItemsRef != nil {
            if shouldBeToggled {
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
                    println("Application was added to login items")
                }
            } else {
                if let itemRef = itemReferences.existingReference {
                    LSSharedFileListItemRemove(loginItemsRef,itemRef);
                    println("Application was removed from login items")
                }
            }
        }
    }
    */
    
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
                println("Application was added to login items")
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
                    println("Application was removed from login items")
                }
        }
    }

    
    
}
