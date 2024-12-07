//
//  Workouts.swift
//  Betus
//
//  Created by Gio's Mac on 03.12.24.
//

import Foundation

struct Workouts: Codable {
    let taskCount: Int
    let time: Int
    let level: Level
    let completers: [String]
    let details: String
    let userId: String?
    let image: String
    let isSelected: Bool

    enum CodingKeys: String, CodingKey {
        case taskCount = "task_count"
        case time
        case level
        case completers
        case details
        case userId = "user_id"
        case image
        case isSelected
    }

    enum Level: String, Codable {
        case easy = "Easy"
        case advance = "Advance"
        case difficult = "Difficult"
        case all = "All"
    }
}
