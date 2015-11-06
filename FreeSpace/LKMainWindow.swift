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
    
    
    
    var fileUnitChangeHandler: ((unit: FileUnit) -> Void)?
    
    
    
    init() {
        super.init(window: nil)
        
        /* Load window from xib file */
        print("****")
        NSBundle.mainBundle().loadNibNamed("LKMainWindow", owner: self, topLevelObjects: nil)
        self.window?.makeKeyAndOrderFront(self)
        self.showWindow(self.window)
        self.window?.delegate = self
        self.window?.title = "FreeSpace"
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
        
        
        self.showNotificationsButton.state = Int(NSUserDefaults.standardUserDefaults().boolForKey("notificationsEnabled"))
        
        
        
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()

        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        print("windowDidLoad")
    }
    
    
    @IBAction func settingsChanged(sender: AnyObject) {
        print("settins changed")
        
        switch sender {
        case self.launchAtLoginButton as NSButton:
            self.updateLaunchAtLoginSettings()
            break
        case self.fileSizeUnitRadioButton as NSMatrix:
            self.updateFileSizeSettings()
            break
        case self.showNotificationsButton as NSButton:
            let state: Bool = Bool((sender as! NSButton).state)
            setNotificationsEnabled(state)
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
        NSUserDefaults.standardUserDefaults().synchronize()
        
        self.fileUnitChangeHandler?(unit: fileUnit)
    }
    
    
    func setNotificationsEnabled(enabled: Bool) {
        NSUserDefaults.standardUserDefaults().setBool(enabled, forKey: "notificationsEnabled")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    
}
