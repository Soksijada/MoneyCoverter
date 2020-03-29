//
//  Formatter.swift
//  MoneyCoverter
//
//  Created by Krešimir Baković on 29/03/2020.
//  Copyright © 2020 Kreso Bakovic. All rights reserved.
//

import Foundation

class Formatter {
    
    static let shared = Formatter()
    
    func replaceAllDotsWithCommas(in string: String) -> String {
        let newString = string.replacingOccurrences(of: ".", with: ",", options: .literal, range: nil)
        return newString
    }
    
    func replaceAllCommasWithDots(in string: String) -> String {
        let newString = string.replacingOccurrences(of: ",", with: ".", options: .literal, range: nil)
        return newString
    }
}
