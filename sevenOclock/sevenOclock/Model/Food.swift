//
//  Food.swift
//  sevenOclock
//
//  Created by Jiyoung Park on 2024/03/25.
//

import Foundation

struct Food {
    let id: UUID
    var count: Int
    var category: Int
    var sellbyDate: Date
    var usebyDate: Date
    var preservation: Int
    var enrollDate: Date
}
