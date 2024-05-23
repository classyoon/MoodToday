//
//  MoodJournalView.swift
//  MoodToday
//
//  Created by Conner Yoon on 5/11/24.
//

import SwiftUI
import SwiftData
enum MoodType : Int, CaseIterable, Codable, Identifiable {
    var id : Self{self}
    case okay, sad, annoyed, happy
    
    var text : String {
        switch self {
        case .happy:
            return "😃 Happy"
        case .annoyed:
            return "😡 Annoyed"
        case .sad:
            return "😭 Sad"
        case .okay:
            return "Insert Icon"
            
        }
    }
}
@Model
class DailyEntry {
    var name = "Nothing"
    var story = "Nothing written"
    var moods : MoodType = MoodType.okay
    init(name: String = "Nothing", moods: MoodType = .okay, story: String = "Nothing written") {
        self.name = name
        self.moods = moods
        self.story = story
    }
}
/*
 Code-able, can make something work with swift data
 */
struct MoodJournalView: View {
    let audio = AudioManager()
    @State private var moodtype : MoodType = MoodType.happy
    @Bindable var examinedDay : DailyEntry
    
    var body: some View {
        
        VStack{
            
            NavigationLink {
                EditTitleView(examinedDay: examinedDay)
            } label: {
                Text(examinedDay.name)
            }
            
            TextField("Write here", text: $examinedDay.name)
            Picker("moodtype", selection: $moodtype){
                ForEach(MoodType.allCases){ type in
                    Text(type.text)
                }
                .onChange(of: moodtype) { newValue in
                    //
                    audio.playSFX(.rightTap)
                }
            }.pickerStyle(.segmented)
        }
    }
    
}


struct MoodListView : View {
    @Environment(\.modelContext) private var modelContext
    @Query private var entries: [DailyEntry]
    var body: some View {
        NavigationStack{
            ForEach(entries){ entry in
                MoodJournalView(examinedDay: entry)
            }
        }
    }
}

#Preview {
    MoodJournalView(examinedDay: DailyEntry())
}
