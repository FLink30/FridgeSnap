//
//  Size.swift
//  FridgeSnap
//
//  Created by Franziska Link on 15.12.23.
//

import Foundation


enum Padding: CGFloat {
    // general Padding /////////////////////////////////////
    case prettyPrettySmall = -48
    case prettySmall = -32
    case small = 8
    case medium = 16
    case large = 32
    case prettyLarge = 56
    
    // Foto Size //////////////////////////////////////////
    case fotoSmall = 34
    case fotoBig = 328
    
    // Foto Size //////////////////////////////////////////
    case sheetFraction = 0.3
    
    // List Item Size /////////////////////////////////////
    case itemHeight = 96
    case itemWidth = 400
    
    // Button Size /////////////////////////////////////
    case buttonWidth = 150
    case buttonHeight = 30
    case buttonStroke = 2

    // Opacity
    case opacitySmall = 0.25
    case opacityMedium = 0.5
    case opacityLarge = 0.6
    case opacityNull = 1
    
    func callAsFunction() -> CGFloat {
        self.rawValue
    }
}
