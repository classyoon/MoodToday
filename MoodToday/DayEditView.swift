//
//  DayEditView.swift
//  MoodToday
//
//  Created by Conner Yoon on 5/22/24.
//

import SwiftUI
import SwiftData
struct DayEditView: View {
    let audio = AudioManager.shared
    @Bindable var day : DailyEntry
    var delete : (DailyEntry)->()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Form{
            TextField("Write Name", text: $day.name)
            Picker("Moods", selection: $day.moods) {
                ForEach(MoodType.allCases){ mood in
                    Text(mood.text)
                }
            }.pickerStyle(.automatic)
            Button("DELETE"){
                delete(day)
                dismiss()
                
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: DailyEntry.self, configurations: config)
    let day = DailyEntry(name: "IDK", moods: MoodType.happy)
    container.mainContext.insert(day)
    return DayEditView(day: day, delete: {_ in})
        .modelContainer(container)
   
}
