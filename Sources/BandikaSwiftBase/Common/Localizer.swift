//
//  File.swift
//  
//
//  Created by Michael Rönnau on 28.03.21.
//

import Foundation

public struct Localizer{

    public static var instance = Localizer()

    public var bundles = Dictionary<String, Bundle>()

    public func localize(src: String) -> String{
        NSLocalizedString(src, comment: "")
    }

    public func localize(src: String, language: String, def: String? = nil) -> String{
        if let bundle = bundles[language]{
            return bundle.localizedString(forKey: src, value: def, table: nil)
        }
        if let bundle = bundles["en"]{
            return bundle.localizedString(forKey: src, value: def, table: nil)
        }
        return src
    }

}
