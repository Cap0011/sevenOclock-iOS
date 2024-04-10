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
    case grain = "곡식·견과"
    case noodle = "면류"
    case side = "반찬"
    case instant = "간편식"
    case sauce = "양념·오일"
    case snack = "간식"
    case beverage = "음료·주류"
    case others = "기타"
    
    static func allCasesStringArray() -> [String] {
        return Category.allCases.map { $0.rawValue }
    }
    
    static func casesStringArray() -> [String] {
        return Category.allCasesStringArray().filter { $0 != "전체" }
    }
    
    static func fromRawValue(rawValue: String) -> Category? {
        return Category(rawValue: rawValue)
    }

    func getSubcategories() -> [String] {
        switch self {
        case .fruit:
            return ["귤", "무화과", "체리", "복숭아", "블루베리", "산딸기", "자두", "포도", "감", "대추", "배", "사과", "석류", "참외", "한라봉", "딸기", "수박", "멜론", "파인애플", "바나나", "토마토", "레몬", "망고", "아보카도", "오렌지", "올리브", "자몽", "키위", "기타"]
        case .vegetable:
            return ["깻잎", "고추", "쑥", "배추", "무", "오이", "시금치", "콩나물", "파", "양파", "양상추", "상추", "양배추", "가지", "호박", "애호박", "당근", "마늘", "버섯", "부추", "우엉", "연근", "도라지", "청경채", "쌈채소", "브로콜리", "파프리카", "콩류", "기타"]
        case .meat:
            return ["소고기", "돼지고기", "닭고기", "오리고기", "양고기", "소시지", "햄", "베이컨", "기타"]
        case .dairy:
            return ["우유", "치즈", "버터", "요거트", "분유", "기타"]
        case .grain:
            return ["쌀", "밀가루", "잡곡", "밤", "아몬드", "잣", "은행", "마카다미아", "호두", "캐슈넛", "땅콩", "기타"]
        case .all:
            return []
        case .seafood:
            return ["도미", "꽁치", "연어", "홍합", "쭈꾸미", "꽃게", "조개", "새우", "전복", "오징어", "고등어", "대구", "전어", "멸치", "낙지", "광어", "해삼", "문어", "대게", "랍스타", "김", "미역", "다시마", "가자미", "갈치", "조기", "기타"]
        case .egg:
            return ["달걀", "구운란", "메추리알", "기타"]
        case .noodle:
            return ["파스타", "라면", "소면", "칼국수면", "메밀면", "우동면", "기타"]
        case .side:
            return ["두부", "묵", "김치", "젓갈", "어묵", "기타"]
        case .instant:
            return ["만두", "카레", "도시락", "샌드위치", "샐러드", "수프", "밀키트", "레토르트", "기타"]
        case .sauce:
            return ["소금", "간장", "된장", "고추장", "식초", "후추", "설탕", "물엿", "꿀", "잼", "참기름", "들기름", "식용유", "기타"]
        case .snack:
            return ["초콜릿", "과자", "떡", "아이스크림", "빵", "쿠키", "케이크", "시리얼", "사탕", "껌", "기타"]
        case .beverage:
            return ["커피", "과일주스", "코코아", "차", "두유", "소주", "맥주", "와인", "위스키", "칵테일", "기타"]
        case .others:
            return ["기타"]
        }
    }
}
