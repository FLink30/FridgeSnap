//
//  FridgeSnapApp.swift
//  FridgeSnap
//
//  Created by Daniel on 12.12.23.
//

import SwiftUI
import SwiftData

@main
struct FridgeSnapApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Product.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch let error {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView(api: ProductApi(mock: false))
        }
        .modelContainer(sharedModelContainer)
    }
}
    
