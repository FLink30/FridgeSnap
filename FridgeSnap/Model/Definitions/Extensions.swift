//
//  Amount.swift
//  FridgeSnap
//
//  Created by Franziska Link on 15.12.23.
//

import Foundation
import SwiftUI
import Combine

// String extension for Picker /////////////////////////////////////
extension String: CaseIterable, PickerData, Identifiable {
    public var id: UUID {
        return UUID()
    }

    public static var allCases: [String] {
        var cases = [String]()
        for i in 1...20 {
            cases.append("\(i)")
        }
        return cases
    }
    func callAsFunction() -> String {
        return self
    }
    
}

// Int extension for Picker /////////////////////////////////////
extension Int: CaseIterable, PickerData, Identifiable, Publisher {
    public typealias Output = Int
    public typealias Failure = Never
    
    public func receive<S>(subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input {
        _ = subscriber.receive(self)
        subscriber.receive(completion: .finished)
    }
    
    public var id: UUID {
        return UUID()
    }
    
    
    public static var allCases: [Int] {
        var cases = [Int]()
        for i in 1...20 {
            cases.append(i)
        }
        return cases
    }
    
    func callAsFunction() -> String {
        return "\(self)"
    }
    
}

// View extension for productItemView  /////////////////////////////////////
extension View {
    func eraseToAnyView() -> AnyView {
        return AnyView(self)
    }
}

// PickerData Protocoll ////////////////////////////////////////////////////
protocol PickerData {
    func callAsFunction() -> String
}
