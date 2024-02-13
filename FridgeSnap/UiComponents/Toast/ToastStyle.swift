//
//  FancyToastStyle.swift
//  FridgeSnap
//
//  Created by Daniel on 22.01.24.
//

import Foundation
import SwiftUI

enum ToastStyle {
    case error
    case warning
    case success
    case info
    case delete
    case deleteList
}

extension ToastStyle {
    
    var themeColor: Color {
        switch self {
        case .error: return Color.red
        case .warning: return Color.orange
        case .info: return Color.blue
        case .success: return Color.green
        case .delete: return Color.red
        case .deleteList: return Color.red
        }
    }
    
    var iconFileName: String {
        switch self {
        case .info: return "info.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .success: return "checkmark.circle.fill"
        case .error: return "xmark.circle.fill"
        case .delete: return "trash.fill"
        case .deleteList: return "trash.fill"

        }
    }
}
