//
//  WorkoutInfo.swift
//  Betus
//
//  Created by Gio's Mac on 03.12.24.
//

import UIKit

struct WorkoutInfo: Codable {
    let id: String
    let image: String
    let name: String
    let description: String
    let likes: Int

    enum CodingKeys: String, CodingKey {
        case id
        case image
        case name
        case description
        case likes
    }
}
