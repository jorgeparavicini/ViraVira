//
//  TextFormatter.swift
//  ViraVira-Info
//
//  Created by Jorge Paravicini on 10/07/16.
//  Copyright © 2016 Jorge Paravicini. All rights reserved.
//

import Foundation

func applyKeywordsMeaning(_ text: String) -> String{
    let string: NSMutableAttributedString = NSMutableAttributedString(string: text)
    let words: [String] = text.components(separatedBy: " ")
    
    let nonAlphanumericCharacterSet: NSMutableCharacterSet = NSMutableCharacterSet.alphanumeric()
    nonAlphanumericCharacterSet.formUnion(with: NSMutableCharacterSet(charactersIn: "*") as CharacterSet)
    nonAlphanumericCharacterSet.invert()
    
    for var word in words {

        word = word.trimmingCharacters(in: nonAlphanumericCharacterSet as CharacterSet)
        let range: NSRange = (string.string as NSString).range(of: word)
        
        if(word.hasPrefix("*") && word.hasSuffix("*")) {
            
            switch word {
            case "*NAME*":
                string.replaceCharacters(in: range, with: "Paravicini")
                
            case "*TIME_NAME*":
                string.replaceCharacters(in: range, with: Date().timeName())
                
            
            case "*DATE*", "*LONG_DATE*":
                let formatter = DateFormatter()
                formatter.dateStyle = .long
                string.replaceCharacters(in: range, with: formatter.string(from: Date()))
                
            case "*SHORT_DATE*":
                let formatter = DateFormatter()
                formatter.dateStyle = .short
                string.replaceCharacters(in: range, with: formatter.string(from: Date()))
                
            case "*MEDIUM_DATE*":
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                string .replaceCharacters(in: range, with: formatter.string(from: Date()))
                
            case "*FULL_DATE*":
                let formatter = DateFormatter()
                formatter.dateStyle = .full
                string.replaceCharacters(in: range, with: formatter.string(from: Date()))
                
                
            default:
                string.replaceCharacters(in: range, with: "")
            }
        }
    }
    
    return string.string
}
