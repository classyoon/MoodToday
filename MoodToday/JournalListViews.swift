//
//  JournalListViews.swift
//  MoodToday
//
//  Created by Conner Yoon on 5/18/24.
//

import SwiftUI
import SwiftData

struct JournalListViews: View {
    var audio = AudioManager()
    @Environment(\.modelContext) private var modelContext
    @Query private var hotels: [DailyEntry]
    var body: some View {
        VStack{
            Text("Today")
            Button("Delete"){
                audio.playSFX(.deleteSFX)
            }
            Button("Add"){
                audio.playSFX(.completeSFX)
            }
            List{
                ForEach(hotels){ day in
                    MoodJournalView(examinedDay: day)
                }
            }
        }
    }
    private func addItem() {
        withAnimation {
            let newItem = DailyEntry()
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(hotels[index])
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: DailyEntry.self, configurations: config)
    container.mainContext.insert(DailyEntry())
    container.mainContext.insert(DailyEntry())
    return JournalListViews()
        .modelContainer(container)
}
