//
//  JournalListViews.swift
//  MoodToday
//
//  Created by Conner Yoon on 5/18/24.
//

import SwiftUI
import SwiftData
struct DayRowView : View {
    var examinedDay : DailyEntry
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(examinedDay.name).bold()
            Text(examinedDay.moods.text)
        }
    }
}
struct DayListView: View {
    let audio = AudioManager.shared
    @Environment(\.modelContext) private var modelContext
    @Query private var entries: [DailyEntry]
    var body: some View {
        NavigationStack{
            List{
                ForEach(entries){ day in
                    NavigationLink {
                       DayEditView(day: day, delete: deleteDay)
                    } label: {
                        DayRowView(examinedDay: day)
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
    private func deleteDay(day : DailyEntry){
        withAnimation{
            modelContext.delete(day)
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: DailyEntry.self, configurations: config)
    container.mainContext.insert(DailyEntry(name: "BDay"))
    container.mainContext.insert(DailyEntry())
    return DayListView()
        .modelContainer(container)
}
