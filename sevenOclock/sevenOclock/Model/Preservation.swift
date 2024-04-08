//
//  Preservation.swift
//  sevenOclock
//
//  Created by Jiyoung Park on 2024/03/27.
//

import Foundation

enum Preservation: String, CaseIterable {
    case fridge = "냉장"
    case freezer = "냉동"
    case room = "상온"
    case all = "전체"
    
    func imageName() -> String {
        switch self {
        case .fridge:
            return "FridgeBackground"
        case .freezer:
            return "Ice"
        case .room:
            return "Room"
        case .all:
            return "Everything"
        }
    }
    
    static func allCasesStringArray() -> [String] {
        return Preservation.allCases.map { $0.rawValue }
    }
    
    static func casesStringArray() -> [String] {
        return Preservation.allCasesStringArray().filter { $0 != "전체" }
    }
    
    static func fromRawValue(rawValue: String) -> Preservation? {
        return Preservation(rawValue: rawValue)
    }
}
