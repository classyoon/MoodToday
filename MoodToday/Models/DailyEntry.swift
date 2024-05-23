//
//  DailyEntry.swift
//  MoodToday
//
//  Created by Conner Yoon on 5/22/24.
//

import Foundation
import SwiftData
enum MoodType : Int, CaseIterable, Codable, Identifiable {
    var id : Self{self}
    case sad, annoyed, happy
    
    var text : String {
        switch self {
        case .happy:
            return "😃 Happy"
        case .annoyed:
            return "😡 Annoyed"
        case .sad:
            return "😭 Sad"
            
        }
    }
}
@Model
class DailyEntry {
    var name = "Nothing"
    var story = "Nothing written"
    var moods : MoodType = MoodType.happy
    init(name: String = "Nothing", moods: MoodType = .happy, story: String = "Nothing written") {
        self.name = name
        self.moods = moods
        self.story = story
    }
}
