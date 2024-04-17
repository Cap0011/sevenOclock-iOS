//
//  RecipeSortOption.swift
//  sevenOclock
//
//  Created by Jiyoung Park on 2024/04/06.
//

import Foundation

enum RecipeSortOption: String, CaseIterable {
//    case bySimilarity = "냉장고 일치 순"
    case byReview = "리뷰 수 순"
    case byView = "조회수 순"
    
    static func allCasesStringArray() -> [String] {
        return RecipeSortOption.allCases.map { $0.rawValue }
    }
}
