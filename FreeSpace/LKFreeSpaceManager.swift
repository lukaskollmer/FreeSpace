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
    
    
    init() {
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
    }
    
    func freeSpaceAsString() -> String {
        
        let error = NSErrorPointer()
        let dictFree: NSDictionary = self.fileManager.attributesOfFileSystemForPath("/", error: error)!
        
        let freeSpace: NSNumber = dictFree[NSFileSystemFreeSize] as NSNumber
        
        let bytesAsInt: Int64 = freeSpace.longLongValue
        
        let bytesAsString: String = self.fileSizeFormatter.stringFromByteCount(bytesAsInt)

        return bytesAsString
    }
    

    func setUnit(unit: FileUnit, completionHandler: (() -> Void)) {
        println("in freespace manager set unit func")
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
}