//
//  Item.swift
//  MoodToday
//
//  Created by Conner Yoon on 5/11/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
