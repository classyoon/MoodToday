//
//  EditTitleView.swift
//  MoodToday
//
//  Created by Conner Yoon on 5/18/24.
//

import SwiftUI
import SwiftData
struct EditTitleView: View {
    @Bindable var examinedDay : DailyEntry
    var body: some View {
        NavigationStack{
            VStack{
                //   Text("Day \(examinedDay.name) was \($examinedDay.mood.text)")
                TextField(examinedDay.story, text: $examinedDay.story)
            }
        }
    }
}

#Preview {
    EditTitleView(examinedDay: DailyEntry())
}
