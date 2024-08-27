/*
 SwiftyBandika CMS - A Swift based Content Management System with JSON Database
 Copyright (C) 2021 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import Foundation
import CommonCrypto

public class UserSecurity{
    
    private static var rounds : UInt32 = 2205
    private static var keyByteCount : Int = 160
    
    public static func verifyPassword(savedHash: String, password: String) -> Bool{
        let passwordHash : String = encryptPassword(password: password)
        if savedHash == passwordHash {
            return true
        }
        return false
    }
    
    public static func encryptPassword(password : String) -> String{
        let hashed = sha256(str: password)
        Log.debug("password hash = \(hashed)")
        return hashed
    }
    
    static func sha256(str: String) -> String {
        if let strData = str.data(using: .utf8) {
            /// #define CC_SHA256_DIGEST_LENGTH     32
            /// Creates an array of unsigned 8 bit integers that contains 32 zeros
            var digest = [UInt8](repeating: 0, count:Int(CC_SHA256_DIGEST_LENGTH))
     
            /// CC_SHA256 performs digest calculation and places the result in the caller-supplied buffer for digest (md)
            /// Takes the strData referenced value (const unsigned char *d) and hashes it into a reference to the digest parameter.
            let _ = strData.withUnsafeBytes {
                CC_SHA256($0.baseAddress, UInt32(strData.count), &digest)
            }
     
            var sha256String = ""
            for byte in digest {
                sha256String += String(format:"%02x", UInt8(byte))
            }
            return sha256String
        }
        return ""
    }
    

}
