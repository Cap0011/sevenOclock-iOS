//
//  ReceiptResponse.swift
//  sevenOclock
//
//  Created by Jiyoung Park on 2024/04/28.
//

import Foundation

// MARK: - ReceiptResponse
struct ReceiptResponse: Codable {
    let version, requestID: String?
    let timestamp: Int?
    let images: [ReceiptImage]?

    enum CodingKeys: String, CodingKey {
        case version
        case requestID = "requestId"
        case timestamp, images
    }
}

// MARK: - Image
struct ReceiptImage: Codable {
    let receipt: Receipt?
    let uid, name, inferResult, message: String?
    let validationResult: ValidationResult?
}

// MARK: - Receipt
struct Receipt: Codable {
    let meta: Meta?
    let result: Result?
}

// MARK: - Meta
struct Meta: Codable {
    let estimatedLanguage: String?
}

// MARK: - Result
struct Result: Codable {
    let storeInfo: StoreInfo?
    let paymentInfo: PaymentInfo?
    let subResults: [SubResult]?
    let totalPrice: TotalPrice?
    let subTotal: [SubTotal]?
}

// MARK: - PaymentInfo
struct PaymentInfo: Codable {
    let date: DateElement?
    let time: Time?
}

// MARK: - DateElement
struct DateElement: Codable {
    let text: String?
    let formatted: DateFormatted?
    let keyText: DateKeyText?
    let confidenceScore: Double?
    let boundingPolys: [BoundingPoly]?
//    let maskingPolys: [JSONAny]?
}

// MARK: - BoundingPoly
struct BoundingPoly: Codable {
    let vertices: [Vertex]?
}

// MARK: - Vertex
struct Vertex: Codable {
    let x, y: Int?
}

// MARK: - DateFormatted
struct DateFormatted: Codable {
    let year, month, day, value: String?
}

enum DateKeyText: String, Codable {
    case empty = ""
    case 이벤트할인 = "이벤트 할인"
    case 전화 = "전화"
    case 총할인액 = "총할인액"
}

// MARK: - Time
struct Time: Codable {
    let text: String?
    let formatted: TimeFormatted?
    let keyText: String?
    let confidenceScore: Double?
    let boundingPolys: [BoundingPoly]?
}

// MARK: - TimeFormatted
struct TimeFormatted: Codable {
    let hour, minute, second: String?
}

// MARK: - StoreInfo
struct StoreInfo: Codable {
    let name: BizNum?
    let subName: DateElement?
    let bizNum: BizNum?
    let addresses: [BizNum]?
    let tel: [DateElement]?
}

// MARK: - BizNum
struct BizNum: Codable {
    let text: String?
    let formatted: BizNumFormatted?
    let keyText: BizNumKeyText?
    let confidenceScore: Double?
    let boundingPolys: [BoundingPoly]?
//    let maskingPolys: [JSONAny]?
}

// MARK: - BizNumFormatted
struct BizNumFormatted: Codable {
    let value: String?
}

enum BizNumKeyText: String, Codable {
    case empty = ""
    case 주소 = "주소"
    case 총구매액 = "총구매액"
}

// MARK: - SubResult
struct SubResult: Codable {
    let items: [Item]?
}

// MARK: - Item
struct Item: Codable {
    let name: BizNum?
    let code, count: DateElement?
    let price: Price?
}

// MARK: - Price
struct Price: Codable {
    let price, unitPrice: BizNum?
}

// MARK: - SubTotal
struct SubTotal: Codable {
    let discountPrice: [DateElement]?
}

// MARK: - TotalPrice
struct TotalPrice: Codable {
    let price: BizNum?
}

// MARK: - ValidationResult
struct ValidationResult: Codable {
    let result: String?
}

struct ReceiptItem: Hashable {
    let id: UUID
    let name: String
    let count: Int
}
