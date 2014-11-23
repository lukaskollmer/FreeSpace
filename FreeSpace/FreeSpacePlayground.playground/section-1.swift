// Playground - noun: a place where people can play

import Cocoa
import Foundation

let description = "This is a playground used to get the return values of the ``attributesOfFileSystemForPath`` return values."

let problem = "The free space returned by the NSFileManager method id not equal to the free space indicated by the system"

let fileManager = NSFileManager.defaultManager()

let error = NSErrorPointer()
let dictFree: NSDictionary = fileManager.attributesOfFileSystemForPath("/", error: error)!


let freeSpace: NSNumber = dictFree[NSFileSystemFreeSize] as NSNumber

let bytesAsInt: Int64 = freeSpace.longLongValue

let bytesAsString: String = NSByteCountFormatter.stringFromByteCount(bytesAsInt, countStyle: NSByteCountFormatterCountStyle.Decimal)
