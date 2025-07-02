//
//  FlickBuyApp.swift
//  FlickBuyApp
//
//  Created by Phu DO on 3/7/25.
//

import SwiftUI
import SwiftData

@main
struct FlickBuyApp: App {
    let sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    @StateObject private var authViewModel = AuthViewModel()

    var body: some Scene {
        WindowGroup {
            if authViewModel.isLoggedIn {
                ContentView()
                    .modelContainer(sharedModelContainer)
                    .environmentObject(authViewModel)
            } else {
                SignInScreen()
                    .environmentObject(authViewModel)
            }
        }
    }
}
