//
//  TemporaryFood.swift
//  sevenOclock
//
//  Created by Jiyoung Park on 2024/04/08.
//

import Foundation

class TemporaryFood: ObservableObject, Identifiable, Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: TemporaryFood, rhs: TemporaryFood) -> Bool {
        return lhs.id == rhs.id
    }
    
    let id: UUID
    @Published var name: String
    @Published var count: Int
    @Published var category: String
    @Published var subcategory: String
    @Published var usebyDate: Date
    @Published var preservation: String
    var enrollDate: Date?

    init(id: UUID) {
        self.id = id
        self.name = ""
        self.count = 1
        self.category = Category.meat.rawValue
        self.subcategory = Category.meat.getSubcategories().first!
        self.usebyDate = Date()
        self.preservation = Preservation.fridge.rawValue
        self.enrollDate = nil
    }
    
    init(id: UUID, name: String) {
        self.id = id
        self.name = name
        self.count = 1
        self.category = Category.meat.rawValue
        self.subcategory = Category.meat.getSubcategories().first!
        self.usebyDate = Date()
        self.preservation = Preservation.fridge.rawValue
        self.enrollDate = nil
    }
}
