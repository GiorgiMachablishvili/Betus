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
    let level: String
    let completers: [String]
    let details: String
    let id: String
    let image: String
    let creatorId: String

    enum CodingKeys: String, CodingKey {
        case taskCount = "task_count"
        case time
        case level
        case completers
        case details
        case id
        case image
        case creatorId = "creator_id"
    }
}
