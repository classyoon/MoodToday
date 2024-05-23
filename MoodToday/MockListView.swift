//
//  MockListView.swift
//  MoodToday
//
//  Created by Conner Yoon on 5/22/24.
//

import SwiftUI

struct MockListView: View {
    @State private var list = ["Happy", "Sad"]
    var body: some View {
        NavigationStack{
            List {
                ForEach(list, id: \.self){ item in
                    NavigationLink {
                        Text(item)
                    } label: {
                        Text(item)
                    }
                }
            }
            .navigationTitle("Our List")
        }
    }
}

#Preview {
    MockListView()
}
