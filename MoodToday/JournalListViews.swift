//
//  JournalListViews.swift
//  MoodToday
//
//  Created by Conner Yoon on 5/18/24.
//

import SwiftUI
import SwiftData
struct MoodListRowView : View {
    var examinedDay : DailyEntry
    
    var body: some View {
        VStack{
            Text(examinedDay.name)
            Text(examinedDay.moods.text)
        }
    }
}
struct JournalListViews: View {
    let audio = AudioManager()
    @Environment(\.modelContext) private var modelContext
    @Query private var entries: [DailyEntry]
    var body: some View {
        NavigationStack{
            List{
                ForEach(entries){ day in
                    NavigationLink {
                        MoodJournalView(examinedDay: day)
                    } label: {
                        MoodListRowView(examinedDay: day)
                    }
                }
            }
            .navigationTitle("Journal List View")
            .toolbar{
                Button("Add"){
                    audio.playSFX(.completeSFX)
                    addItem()
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
                modelContext.delete(entries[index])
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: DailyEntry.self, configurations: config)
    container.mainContext.insert(DailyEntry(name: "BDay"))
    container.mainContext.insert(DailyEntry())
    return JournalListViews()
        .modelContainer(container)
}
