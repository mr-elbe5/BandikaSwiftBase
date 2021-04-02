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

    public func initialize(languages: Array<String>, bundleLocation: String){
        Log.info("initializing languages")
        for lang in languages{
            let path = bundleLocation.appendPath(lang + ".lproj")
            if let bundle = Bundle(path: path){
                Localizer.instance.bundles[lang] = bundle
                Log.info("found language bundle for '\(lang)'")
            }
            else{
                Log.warn("language bundle not found at \(path)")
            }
        }
    }

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
