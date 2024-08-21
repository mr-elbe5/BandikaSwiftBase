//
//  ImageMagick.swift
//  ImageMagickTest
//
//  Created by Michael Rönnau on 29.07.22.
//

import Foundation

public struct ImageMagick{
    
    public static var magickPath = ""
    
    public static func enable(path: String) -> Bool{
        let task = Process()
        task.launchPath = path
        task.arguments = ["-version"]
        task.launch()
        task.waitUntilExit()
        if task.terminationStatus == 0{
            ImageMagick.magickPath = path
            return true
        }
        return false
    }
    
    @discardableResult
    public static func copy(path: String, from: String, to: String) -> Bool{
        return copy(from: path + from, to: path + to)
    }
    
    @discardableResult
    public static func copy(from: String, to: String) -> Bool{
        return run(args: [
            from,
            to
        ])
    }
    
    @discardableResult
    public static func copy(from: String, to: String, newSize: NSSize) -> Bool{
        return run(args: [
            from,
            "-resize \(Int(newSize.width))x\(Int(newSize.height))",
            to
        ])
    }
    
    @discardableResult
    public static func run(args : [String]) -> Bool{
        let task = Process()
        task.launchPath = magickPath
        task.arguments = args
        task.launch()
        task.waitUntilExit()
        return task.terminationStatus == 0
    }
    
}
    
