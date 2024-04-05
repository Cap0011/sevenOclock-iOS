//
//  Food.swift
//  sevenOclock
//
//  Created by Jiyoung Park on 2024/03/25.
//

import Foundation

struct Food: Identifiable, Hashable {
    let id: UUID
    var name: String
    var count: Int
    var category: Category
    var sellbyDate: Date
    var usebyDate: Date
    var preservation: Preservation
    var enrollDate: Date
}

extension Food {
    static let dummyData = Food(id: UUID(), name: "돼지고기", count: 3, category: .meat, sellbyDate: Date(), usebyDate: Date(), preservation: .fridge, enrollDate: Date())
    static let dummyData1 = Food(id: UUID(), name: "돼지고기", count: 3, category: .meat, sellbyDate: Date(), usebyDate: Date(), preservation: .fridge, enrollDate: Date())
    static let dummyData2 = Food(id: UUID(), name: "돼지고기", count: 3, category: .meat, sellbyDate: Date(), usebyDate: Date(), preservation: .fridge, enrollDate: Date())
    static let dummyData3 = Food(id: UUID(), name: "돼지고기", count: 3, category: .meat, sellbyDate: Date(), usebyDate: Date(), preservation: .fridge, enrollDate: Date())
}
