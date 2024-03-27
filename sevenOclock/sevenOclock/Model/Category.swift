//
//  Category.swift
//  sevenOclock
//
//  Created by Jiyoung Park on 2024/03/26.
//

import Foundation

enum Category: String, CaseIterable {
    case all = "전체"
    case meat = "육류"
    case seafood = "수산물"
    case dairy = "유제품"
    case egg = "계란"
    case vegetable = "채소"
    case fruit = "과일"
    case mushroom = "버섯"
    case grain = "곡식·견과"
    case noodle = "면류"
    case instant = "간편식"
    case sauce = "양념"
    case snack = "간식"
    case beverage = "음료"
    case others = "기타"
}
