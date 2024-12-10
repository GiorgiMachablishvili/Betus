//
//  LikeResponse.swift
//  Betus
//
//  Created by Gio's Mac on 06.12.24.
//

import Foundation

struct LikeResponse: Codable {
    let userId: Int
    let id: Int
    let isSelected: Bool

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case id
        case isSelected
    }
}



