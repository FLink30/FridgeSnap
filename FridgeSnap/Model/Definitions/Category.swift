//
//  Categories.swift
//  FridgeSnap
//
//  Created by Franziska Link on 21.01.24.
//

import Foundation
import SwiftData

enum Category: String, CaseIterable, PickerData, Codable, Hashable {
    case other
    case meat
    case vegetables
    case beverage
    case dairies
    case cereals
    case fruits
    
    func callAsFunction() -> String {
        self.rawValue.capitalized
    }
}
