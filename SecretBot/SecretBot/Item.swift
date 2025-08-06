//
//  Item.swift
//  SecretBot
//
//  Created by 生駒岳太郎 on 2025/08/06.
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
