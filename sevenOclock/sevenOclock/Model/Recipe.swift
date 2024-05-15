//
//  Recipe.swift
//  sevenOclock
//
//  Created by Jiyoung Park on 2024/04/05.
//

import Foundation

struct Recipe: Codable, Equatable {
    let ID: Int
    var name: String
    var imageURL: String
    var link: String
    var ingredients: [String]
    var reviewNumber: Int
    var viewNumber: Int
    var similarity: Int?
}
