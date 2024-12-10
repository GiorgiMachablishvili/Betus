//
//  Task.swift
//  Betus
//
//  Created by Gio's Mac on 10.12.24.
//

import Foundation

struct Task {
    let title: String
    let time: String
    let description: String

    public init(title: String, time: String, description: String) {
        self.title = title
        self.time = time
        self.description = description
    }
}

