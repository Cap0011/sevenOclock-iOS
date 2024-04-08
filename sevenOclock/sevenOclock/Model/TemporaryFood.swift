//
//  TemporaryFood.swift
//  sevenOclock
//
//  Created by Jiyoung Park on 2024/04/08.
//

import Foundation

struct TemporaryFood: Identifiable, Hashable {
    let id: UUID
    var name: String = ""
    var count: Int = 1
    var category: Category?
    var usebyDate: Date = Date()
    var preservation: Preservation?
    var enrollDate: Date?
}
