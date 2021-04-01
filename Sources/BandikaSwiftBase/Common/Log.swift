/*
 SwiftyBandika CMS - A Swift based Content Management System with JSON Database
 Copyright (C) 2021 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import Foundation

public protocol LogDelegate{
    func updateLog()
}

public class Log{

    public static var delegate : LogDelegate? = nil
    
    public static var logFileUrl = Paths.logFile.toFileUrl()!
    
    public static func info(_ string: String){
        log(string,level: .info)
    }
    
    public static func warn(_ string: String){
        log(string,level: .warn)
    }
    
    public static func error(_ string: String){
        log(string,level: .error)
    }

    public static func error(error: Error){
        log(error.localizedDescription,level: .error)
    }
    
    public static func log(_ string: String, level : LogLevel){
        let msg = level.rawValue + Date().dateTimeString() + " " + string
        Files.appendToFile(text: msg + "\n", url: logFileUrl)
        delegate?.updateLog()
    }
}
