//
//  ReceiptResponse.swift
//  sevenOclock
//
//  Created by Jiyoung Park on 2024/04/28.
//

import Foundation

// MARK: - ReceiptResponse
struct ReceiptResponse: Codable {
    let version, requestID: String
    let timestamp: Int
    let images: [ReceiptImage]

    enum CodingKeys: String, CodingKey {
        case version
        case requestID = "requestId"
        case timestamp, images
    }
}

// MARK: - Image
struct ReceiptImage: Codable {
    let receipt: Receipt
    let uid, name, inferResult, message: String
    let validationResult: ValidationResult
}

// MARK: - Receipt
struct Receipt: Codable {
    let meta: Meta
    let result: Result
}

// MARK: - Meta
struct Meta: Codable {
    let estimatedLanguage: String
}

// MARK: - Result
struct Result: Codable {
    let storeInfo: StoreInfo
    let paymentInfo: PaymentInfo
    let subResults: [SubResult]
    let totalPrice: TotalPrice
}

// MARK: - PaymentInfo
struct PaymentInfo: Codable {
    let date: DateClass
    let time: Time
    let cardInfo: CardInfo
    let confirmNum: ConfirmNum
}

// MARK: - CardInfo
struct CardInfo: Codable {
    let company, number: BizNum
}

// MARK: - BizNum
struct BizNum: Codable {
    let text: String
    let formatted: BizNumFormatted
    let boundingPolys: [BoundingPoly]
}

// MARK: - BoundingPoly
struct BoundingPoly: Codable {
    let vertices: [Vertex]
}

// MARK: - Vertex
struct Vertex: Codable {
    let x, y: Int
}

// MARK: - BizNumFormatted
struct BizNumFormatted: Codable {
    let value: String
}

// MARK: - ConfirmNum
struct ConfirmNum: Codable {
    let text: String
    let boundingPolys: [BoundingPoly]
}

// MARK: - DateClass
struct DateClass: Codable {
    let text: String
    let formatted: DateFormatted
    let boundingPolys: [BoundingPoly]
}

// MARK: - DateFormatted
struct DateFormatted: Codable {
    let year, month, day: String
}

// MARK: - Time
struct Time: Codable {
    let text: String
    let formatted: TimeFormatted
    let boundingPolys: [BoundingPoly]
}

// MARK: - TimeFormatted
struct TimeFormatted: Codable {
    let hour, minute, second: String
}

// MARK: - StoreInfo
struct StoreInfo: Codable {
    let name, subName, bizNum: BizNum
    let addresses, tel: [BizNum]
}

// MARK: - SubResult
struct SubResult: Codable {
    let items: [Item]
}

// MARK: - Item
struct Item: Codable {
    let name, count: BizNum
    let price: Price
}

// MARK: - Price
struct Price: Codable {
    let price, unitPrice: BizNum
}

// MARK: - TotalPrice
struct TotalPrice: Codable {
    let price: BizNum
}

// MARK: - ValidationResult
struct ValidationResult: Codable {
    let result: String
}

struct ReceiptItem: Hashable {
    let id: UUID
    let name: String
    let count: Int
}
