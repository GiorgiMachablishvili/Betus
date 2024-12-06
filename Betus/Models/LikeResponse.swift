//
//  LikeResponse.swift
//  Betus
//
//  Created by Gio's Mac on 06.12.24.
//

import Foundation

struct LikeResponse: Codable {
    let taskCount: Int
    let time: Int
    let level: String
    let details: String
    let isSelected: Bool

    enum CodingKeys: String, CodingKey {
        case taskCount = "task_count"
        case time
        case level
        case details
        case isSelected
    }
}



