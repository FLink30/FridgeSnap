//
//  Unit.swift
//  FridgeSnap
//
//  Created by Franziska Link on 14.01.24.
//

import Foundation
import SwiftData
import Combine

// Unit of Amount for Picker /////////////////////////////////////
enum Unit: String, CaseIterable, PickerData, Codable, Hashable {
    case count
    case gram
    case kilogram
    case mililiter
    
    func callAsFunction() -> String {
        self.rawValue.capitalized
    }
    
    // abbreviation for elements in picker /////////////////////////
    func abbr() -> String {
        switch self {
        case .count:
            return "times"
        case .gram:
            return "g"
        case .kilogram:
            return "kg"
        case .mililiter:
            return "ml"
        }
    }
   
}

