/*
 SwiftyBandika CMS - A Swift based Content Management System with JSON Database
 Copyright (C) 2021 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import Foundation
import SwiftyLog

public class Statics: Codable{

    public static var instance = Statics()

    public static var title = "Swifty Bandika"
    public static var startSize = NSMakeSize(1000, 750)

    public static func initialize(){
        Log.info("initializing statics")
        if !Files.fileExists(path: Paths.staticsFile){
            instance.initDefaults()
            if !instance.save(){
                Log.error("could not save statics")
            }
            else {
                Log.info("created statics")
            }
        }
        if let str = Files.readTextFile(path: Paths.staticsFile){
            if let statics : Statics = Statics.fromJSON(encoded: str){
                instance = statics
                Log.info("loaded app statics")
                if !statics.save(){
                    Log.warn("statics could not be saved")
                }
            }
        }
    }
    
    private enum SectionDataCodingKeys: CodingKey{
        case salt
        case defaultPassword
        case defaultLocale
        case cleanupInterval
    }
    
    public var salt: String
    public var defaultPassword: String
    public var defaultLocale: Locale
    public var cleanupInterval : Int = 10

    public required init(){
        salt = ""
        defaultPassword = ""
        defaultLocale = Locale(identifier: "en")
    }
    
    public required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: SectionDataCodingKeys.self)
        salt = try values.decodeIfPresent(String.self, forKey: .salt) ?? UserSecurity.generateSaltString()
        defaultPassword = try values.decodeIfPresent(String.self, forKey: .defaultPassword) ?? ""
        defaultLocale = try values.decodeIfPresent(Locale.self, forKey: .defaultLocale) ?? Locale.init(identifier: "en")
        cleanupInterval = try values.decodeIfPresent(Int.self, forKey: .cleanupInterval) ?? 10
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: SectionDataCodingKeys.self)
        try container.encode(salt, forKey: .salt)
        try container.encode(defaultPassword, forKey: .defaultPassword)
        try container.encode(defaultLocale, forKey: .defaultLocale)
    }
    
    public func initDefaults(){
        salt = UserSecurity.generateSaltString()
        defaultPassword =  UserSecurity.encryptPassword(password: "pass", salt: salt)
        defaultLocale = Locale(identifier: "en")
    }
    
    public func save() -> Bool{
        Log.info("saving app statics")
        let json = toJSON()
        if !Files.saveFile(text: json, path: Paths.staticsFile){
            Log.warn("\(Paths.staticsFile) not saved")
            return false
        }
        return true
    }
    
}
