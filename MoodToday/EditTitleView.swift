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
        VStack{
            TextField("Type", text: $examinedDay.name)
        }
    }
}

#Preview {
    EditTitleView(examinedDay: DailyEntry())
}
