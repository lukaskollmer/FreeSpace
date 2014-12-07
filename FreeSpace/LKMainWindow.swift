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
        case self.showNotificationsButton as NSButton:
            if self.showNotificationsButton.state == 0 {
                self.setAllNotificationButtonsEnabledState(false)
            }
            if self.showNotificationsButton.state == 1 {
                self.setAllNotificationButtonsEnabledState(true)
            }
            break
        case self.notifyAt2GbButton as NSButton, self.notifyAt5GbButton as NSButton, self.notifyAt10GbButton as NSButton, self.notifyAt15GbButton as NSButton, self.notifyAt25GbButton as NSButton, self.notifyAt50GbButton as NSButton:
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
    
    
    func setAllNotificationButtonsEnabledState(state: Bool) {
        println("setAllNotificationButtonsEnabledState: \(state)")
        let notificationButtons: [NSButton] = [self.notifyAt2GbButton, self.notifyAt5GbButton, self.notifyAt10GbButton, self.notifyAt15GbButton, self.notifyAt25GbButton, self.notifyAt50GbButton]
        
        for button in notificationButtons {
            button.enabled = state
        }
    }
    func updateNotificationSettings() {
        
    }
    
    
}
