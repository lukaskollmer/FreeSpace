//
//  LKFreeSpaceManager.swift
//  FreeSpace
//
//  Created by Lukas Kollmer on 23/11/14.
//  Copyright (c) 2014 Lukas Kollmer. All rights reserved.
//

import Foundation

class LKFreeSpaceManager {
    
    let fileManager = NSFileManager.defaultManager()
    
    let fileSizeFormatter = NSByteCountFormatter()
    let notificationLevelFileSizeFormatter = NSByteCountFormatter()

    let notificationLevels: [LKNotificationLevel]? = []
    
    
    init(notificationLevels: [LKNotificationLevel]?) {
        let fileUnit: FileUnit = FileUnit(int: NSUserDefaults.standardUserDefaults().integerForKey("fileUnit"))
        
        switch fileUnit {
        case .Automatic:
            self.fileSizeFormatter.allowedUnits = .UseAll
            break
        case .GB:
            self.fileSizeFormatter.allowedUnits = .UseGB
            break
        default:
            self.fileSizeFormatter.allowedUnits = .UseAll
            break
        }
        
        
        self.fileSizeFormatter.countStyle = .File
        self.fileSizeFormatter.includesUnit = true

        self.notificationLevelFileSizeFormatter.countStyle = .File
        self.notificationLevelFileSizeFormatter.includesUnit = false
        self.notificationLevelFileSizeFormatter.includesCount = true


        // Init the Notification stuff
        //self.notificationLevels = notificationLevels
    }
    
    func queryInfoFromFileSystemAttributes(query: String) -> AnyObject {
        let error = NSErrorPointer()
        let dict: NSDictionary = try! self.fileManager.attributesOfFileSystemForPath("/")
        
        return dict[query]!
    }

    
    func freeSpaceAsString() -> String {
        
        let freeSpace = queryInfoFromFileSystemAttributes(NSFileSystemFreeSize) as! NSNumber
        
        let bytesAsInt: Int64 = freeSpace.longLongValue
        
        let bytesAsString: String = self.fileSizeFormatter.stringFromByteCount(bytesAsInt)

        // Before returning the function, "save" the count for notification purposes

        return bytesAsString
    }
    
    
    func totalSpaceAsString() -> String {
        let totalSpace = queryInfoFromFileSystemAttributes(NSFileSystemSize) as! NSNumber
        
        let bytesAsInt: Int64 = totalSpace.longLongValue
        
        let totalAsString: String = self.fileSizeFormatter.stringFromByteCount(bytesAsInt)
        
        
        return totalAsString
    }
    

    func setUnit(unit: FileUnit, completionHandler: (() -> Void)) {
        print("in freespace manager set unit func")
        switch unit {
        case .Automatic:
            self.fileSizeFormatter.allowedUnits = .UseAll
            break
        case .GB:
            self.fileSizeFormatter.allowedUnits = .UseGB
            break
        }
        
        completionHandler()
    }

    //private func notificationIsNeeded() -> Bool {
    //
    //}
}