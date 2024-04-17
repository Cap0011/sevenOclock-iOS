//
//  Recipe.swift
//  sevenOclock
//
//  Created by Jiyoung Park on 2024/04/05.
//

import Foundation

struct Recipe: Codable {
    let ID: Int
    var name: String
    var imageURL: String
    var link: String
    var ingredients: [String]
    var reviewNumber: Int
    var viewNumber: Int
    var similarity: Int?
}

//extension Recipe {
//    static let dummyData = [Recipe(id: "0", name: "모닝빵 속에 옥수수가 에어프라이어 옥수수 치즈빵 옥수수 치즈빵", time: 15, portion: 4, imageURL: "https://recipe1.ezmember.co.kr/cache/recipe/2022/11/30/59e2990d72d83f54f47d9f858d6146ff1_m.jpg", link: "https://www.10000recipe.com/recipe/6994258", ingredients: ["계란", "양배추", "치즈", "베이컨", "시금치", "오리고기"], reviewNumber: 153, viewNumber: 265000, similarity: 60),
//                            Recipe(id: "1", name: "부추 베이컨 말이", time: 15, portion: 4, imageURL: "https://recipe1.ezmember.co.kr/cache/recipe/2022/11/30/59e2990d72d83f54f47d9f858d6146ff1_m.jpg", link: "https://www.10000recipe.com/recipe/6994258", ingredients: ["계란", "양배추", "치즈", "베이컨", "시금치", "오리고기"], reviewNumber: 153, viewNumber: 265000, similarity: 60),
//                            Recipe(id: "2", name: "모닝빵 속에 옥수수가 에어프라이어 옥수수 치즈빵 옥수수 치즈빵 모닝빵 속에 옥수수가 에어프라이어 옥수수 치즈빵 옥수수 치즈빵 모닝빵 속에 옥수수가 에어프라이어 옥수수 치즈빵 옥수수 치즈빵 모닝빵 속에 옥수수가 에어프라이어 옥수수 치즈빵 옥수수 치즈빵", time: 15, portion: 4, imageURL: "https://recipe1.ezmember.co.kr/cache/recipe/2022/11/30/59e2990d72d83f54f47d9f858d6146ff1_m.jpg", link: "https://www.10000recipe.com/recipe/6994258", ingredients: ["계란", "양배추", "치즈", "베이컨", "시금치", "오리고기"], reviewNumber: 153, viewNumber: 265000, similarity: 60),
//                            Recipe(id: "3", name: "모닝빵 속에 옥수수가 에어프라이어 옥수수 치즈빵 옥수수 치즈빵", time: 15, portion: 4, imageURL: "https://recipe1.ezmember.co.kr/cache/recipe/2022/11/30/59e2990d72d83f54f47d9f858d6146ff1_m.jpg", link: "https://www.10000recipe.com/recipe/6994258", ingredients: ["계란", "양배추", "치즈", "베이컨", "시금치", "오리고기"], reviewNumber: 153, viewNumber: 265000, similarity: 60)]
//}
