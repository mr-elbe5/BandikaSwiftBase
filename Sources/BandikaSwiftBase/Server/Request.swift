/*
 SwiftyBandika CMS - A Swift based Content Management System with JSON Database
 Copyright (C) 2021 Michael Roennau

 This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 3 of the License, or (at your option) any later version.
 This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 You should have received a copy of the GNU General Public License along with this program; if not, see <http://www.gnu.org/licenses/>.
*/

import Foundation
import NIO
import NIOHTTP1

public class Request {
    
    public var path: String = ""
    public var method: HTTPMethod = .GET
    public var uri: String = ""
    public var headers: [String: String] = [:]
    public var language = "en"
    public var bytes = [UInt8]()
    public var params: [String: Any] = [:]
    public var files = [String:MemoryFile]()
    public var session : Session? = nil
    public var viewType : ViewType = .show
    public var message : Message? = nil
    public var formError: FormError? = nil
    public var pageVars = [String: String]()

    public var address : String?{
        get{
            headers["host"]
        }
    }

    public var referer : String?{
        get{
            headers["referer"]
        }
    }

    public var userAgent : String?{
        get{
            headers["user-agent"]
        }
    }

    public var accept : String?{
        get{
            headers["accept"]
        }
    }

    public var acceptLanguage : String?{
        get{
            headers["accept-language"]
        }
    }

    public var keepAlive : Bool{
        get{
            headers["connection"] == "keep-alive"
        }
    }

    public var contentTypeTokens : [String]{
        get{
            if let contentTypeHeader = headers["content-type"]{
                return contentTypeHeader.components(separatedBy: ";").map { $0.trimmingCharacters(in: .whitespaces) }
            }
            return []
        }
    }

    public var contentType : String{
        get{
            let tokens = contentTypeTokens
            return tokens.first ?? ""
        }
    }

    public var contentLength : Int?{
        get{
            Int(headers["content-length"] ?? "")
        }
    }

    public var sessionId: String{
        get{
            if let cookies = headers["cookie"]?.split(";"){
                for cookie in cookies{
                    let cookieParts = cookie.split("=")
                    if cookieParts[0].trim().lowercased() == "sessionid"{
                        return cookieParts[1].trim()
                    }
                }
            }
            return ""
        }
    }

    public var user : UserData?{
        get{
            session?.user
        }
    }

    public var isLoggedIn: Bool {
        get {
            user != nil
        }
    }

    public var userId: Int {
        get {
            user == nil ? 0 : user!.id
        }
    }

    public var hasMessage: Bool {
        get {
            message != nil
        }
    }

    public var hasFormError: Bool {
        get {
            formError != nil && !formError!.isEmpty
        }
    }

    public init(){
    }

    public func setLanguage(){
        if var lang = acceptLanguage{
            lang = lang.lowercased()
            if lang.count > 2{
                lang = String(lang[lang.startIndex...lang.index(lang.startIndex, offsetBy: 1)])
            }
            language = lang
        }
        else {
            language = "en"
        }
    }

    public func setParam(_ name: String, _ value: Any){
        params[name] = value
    }

    public func removeParam(_ name: String){
        params[name] = nil
    }

    public func getParam(_ name: String) -> Any?{
        params[name]
    }

    public func getParam<T>(_ name: String, type: T.Type) -> T?{
        getParam(name) as? T
    }

    public func getString(_ name: String, def: String = "") -> String{
        if let s = getParam(name) as? String {
            return s
        }
        if let arr = getParam(name) as? Array<String> {
            return arr.first ?? def
        }
        return def
    }

    public func getStringArray(_ name: String) -> Array<String>?{
        getParam(name) as? Array<String>
    }

    public func getInt(_ name: String, def: Int = -1) -> Int{
        let s = getString(name)
        return Int(s) ?? def
    }

    public func getIntArray(_ name: String) -> Array<Int>?{
        if let stringSet = getStringArray(name){
            var array = Array<Int>()
            for s in stringSet{
                if let i = Int(s){
                    array.append(i)
                }
            }
            return array
        }
        return nil
    }

    public func getBool(_ name: String) -> Bool{
        let s = getString(name)
        return Bool(s) ?? false
    }

    public func getFile(_ name: String) -> MemoryFile?{
        print("files: \(files.keys)")
        return files[name]
    }

    public func setSessionAttribute(_ name: String, value: Any){
        session?.setAttribute(name, value: value)
    }

    public func removeSessionAttribute(_ name: String){
        session?.removeAttribute(name)
    }

    public func getSessionAttributeNames() -> Set<String>{
        session?.getAttributeNames() ?? Set<String>()
    }

    public func getSessionAttribute(_ name: String) -> Any?{
        session?.getAttribute(name)
    }

    public func getSessionAttribute<T>(_ name: String, type: T.Type) -> T?{
        getSessionAttribute(name) as? T
    }

    public func getSessionString(_ name: String, def : String = "") -> String{
        getSessionAttribute(name) as? String ?? def
    }

    public func getSessionInt(_ name: String, def: Int = -1) -> Int{
        if let i = getSessionAttribute(name) as? Int{
            return i
        }
        if let s = getSessionAttribute(name) as? String{
            return Int(s) ?? def
        }
        return def
    }

    public func getSessionBool(_ name: String) -> Bool{
        if let b = getSessionAttribute(name) as? Bool{
            return b
        }
        if let s = getSessionAttribute(name) as? String{
            return Bool(s) ?? false
        }
        return false
    }

    public func addPageVar(_ name: String,_ value: String){
        pageVars[name] = value
    }

    public func addConditionalPageVar(_ name: String,_ value: String, if condition: Bool){
        if condition{
            addPageVar(name, value)
        }
    }

    public func setMessage(_ msg: String, type: MessageType) {
        message = Message(type: type, text: msg)
    }

    public func getFormError(create: Bool) -> FormError {
        if formError == nil && create {
            formError = FormError()
        }
        return formError!
    }

    public func addFormError(_ s: String) {
        getFormError(create: true).addFormError(s)
    }

    public func addFormField(_ field: String) {
        getFormError(create: true).addFormField(field)
    }

    public func addIncompleteField(_ field: String) {
        getFormError(create: true).addFormField(field)
        getFormError(create: false).formIncomplete = true
    }

    public func hasFormErrorField(_ name: String) -> Bool {
        if formError == nil {
            return false
        }
        return formError!.hasFormErrorField(name: name)
    }

    public func dump() {
        Log.info(">>start request")
        Log.info("method = \(method.rawValue)")
        Log.info("uri = \(uri)")
        Log.info("path = \(path)")
        Log.info("params = \(params)")
        Log.info("pageVars = \(pageVars)")
        Log.info("address = \(address ?? "")")
        Log.info("referer = \(referer ?? "")")
        Log.info("user agent = \(userAgent ?? "")")
        Log.info("keepAlive = \(keepAlive)")
        Log.info("contentType = \(contentType)")
        Log.info("content length = \(contentLength ?? -1)")
        Log.info("sessionId = \(sessionId)")
        if session != nil {
            Log.info("sessionAttributes = \(session!.attributes)")
        }
        Log.info("<<end request")
    }

}
