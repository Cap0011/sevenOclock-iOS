//
//  FoodData.swift
//  sevenOclock
//
//  Created by Jiyoung Park on 2024/04/18.
//

import Foundation

struct FoodDataModel: Codable {
    let C005: FoodData

    struct FoodData: Codable {
        let total_count: String
        let row: [Product]?
        let RESULT: Result

        struct Product: Codable {
            let CLSBIZ_DT: String
            let SITE_ADDR: String
            let PRDLST_REPORT_NO: String
            let PRMS_DT: String
            let PRDLST_NM: String
            let BAR_CD: String
            let POG_DAYCNT: String
            let PRDLST_DCNM: String
            let BSSH_NM: String
            let END_DT: String
            let INDUTY_NM: String
        }

        struct Result: Codable {
            let MSG: String
            let CODE: String
        }
    }
}
