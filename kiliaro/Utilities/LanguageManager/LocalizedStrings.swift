//
//  LocalizedStrings.swift
//  kiliaro
//
//  Created by Emad Bayramy on 12/5/21.
//

import Foundation

// We can also using swiftgen for generating string files
enum LocalizedStrings: String {
    
    case toHome = "to_home"
    case changeLanguage
    case controllFlowNotelabel
    case size
    case cancel
    case urlError
    case myImages
    
    var value: String {
        return localized(key: self.rawValue)
    }
    
    private func localized(key: String) -> String {
        return NSLocalizedString(key, comment: "")
    }
}
