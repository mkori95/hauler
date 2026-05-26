//
//  Item.swift
//  hauler
//
//  Created by Manikanta Bharadwaj Koride on 5/25/26.
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
