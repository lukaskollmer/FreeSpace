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
    
    func freeSpaceAsString() -> String {
        
        let error = NSErrorPointer()
        let dictFree: NSDictionary = self.fileManager.attributesOfFileSystemForPath("/", error: error)!
        
        let freeSpace: NSNumber = dictFree[NSFileSystemFreeSize] as NSNumber
        
        let bytesAsInt: Int64 = freeSpace.longLongValue
        
        let bytesAsString: String = NSByteCountFormatter.stringFromByteCount(bytesAsInt, countStyle: NSByteCountFormatterCountStyle.File)

        return bytesAsString
    }
    

}