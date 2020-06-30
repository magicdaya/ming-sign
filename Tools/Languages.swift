//
//  Languages.swift
//  ming sign
//
//  Created by magicday.a on 24.01.20.
//  Copyright © 2020 magicdaya. All rights reserved.
//

import SwiftUI
import UIKit

struct Languages {

    static func getEntryFromJSON(section: SwitchSection, entry: SwitchEntry) -> String {
        // get current language from settings
        let language = ImageStorage.retrieveLanguage()
     //   print("language: \(language)")
        let url = Bundle.main.url(forResource: language, withExtension: "JSON")
        
        guard let jsonData = url else { return "there is no url" }
        guard let data = try? Data(contentsOf: jsonData) else { return "there is no jasonData" }
        guard let json = try? JSONSerialization.jsonObject(with: data, options: []) else { return "there is no json" }
        
        if let dictionary = json as? [String: Any] {
            if let nestedDictionary = dictionary[section.rawValue] as? [String: Any] {
                if let entry = nestedDictionary[entry.rawValue] as? String {
                    return entry
                }
            }
        }

        return "there is no entry data"
    }
    
    static func retrieveLanguage() {
        
    }
    
}

enum SwitchLanguages: String {
    case english = "english"
    case deutsch = "deutsch"
}

enum SwitchSection: String {
    case create = "create"
    case sign = "sign"
    case settings = "settings"
    case about = "about"
}

enum SwitchEntry: String {
    case sectionheader = "sectionheader"
    case header1 = "header1"
    case header2 = "header2"
    case header3 = "header3"
    case header4 = "header4"
    case header5 = "header5"
    case header6 = "header6"
    case header7 = "header7"
    case header8 = "header8"
    case header9 = "header9"
    case header10 = "header10"
    case header11 = "header11"
    case header12 = "header12"
    case header13 = "header13"
    case header14 = "header14"
    case header15 = "header15"
    case header16 = "header16"
    case description1 = "description1"
    case description2 = "description2"
    case description3 = "description3"
    case description4 = "description4"
    case description5 = "description5"
    case description6 = "description6"
}
