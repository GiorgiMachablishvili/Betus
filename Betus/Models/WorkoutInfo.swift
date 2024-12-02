//
//  WorkoutInfo.swift
//  Betus
//
//  Created by Gio's Mac on 03.12.24.
//

import SnapKit

struct WorkoutInfo: Decodable {
    let id: String
    let image: String
    let name: String
    let description: String
    let likes: Int
}
