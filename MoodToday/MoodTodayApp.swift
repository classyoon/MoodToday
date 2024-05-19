//
//  MoodTodayApp.swift
//  MoodToday
//
//  Created by Conner Yoon on 5/11/24.
//

import SwiftUI
import SwiftData

@main
struct MoodTodayApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([ DailyEntry.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            JournalListViews()
        }
        .modelContainer(sharedModelContainer)
    }
}
