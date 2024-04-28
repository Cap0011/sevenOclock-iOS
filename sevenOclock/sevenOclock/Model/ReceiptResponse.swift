//
//  ReceiptResponse.swift
//  sevenOclock
//
//  Created by Jiyoung Park on 2024/04/28.
//

import Foundation

struct ReceiptResponse: Codable {
    let version: String
    let requestId: String
    let timestamp: TimeInterval
    let images: [ReceiptImage]
}

struct ReceiptImage: Codable {
    let receipt: Receipt
    let uid: String
    let name: String
    let inferResult: String
    let message: String
    let validationResult: ValidationResult
}

struct Receipt: Codable {
    let meta: Meta
    let result: Result
}

struct Meta: Codable {
    let estimatedLanguage: String
}

struct Result: Codable {
    let storeInfo: StoreInfo
    let paymentInfo: PaymentInfo
    let subResults: [SubResult]
    let totalPrice: Price
}

struct StoreInfo: Codable {
    let name: InfoText
    let subName: InfoText
    let bizNum: InfoText
    let addresses: [InfoText]
    let tel: [InfoText]
}

struct InfoText: Codable {
    let text: String
    let formatted: FormattedText
    let boundingPolys: [[Vertex]]
}

struct FormattedText: Codable {
    let value: String
}

struct Vertex: Codable {
    let x: Double
    let y: Double
}

struct PaymentInfo: Codable {
    let date: InfoText
    let time: InfoText
    let cardInfo: CardInfo
    let confirmNum: InfoText
}

struct CardInfo: Codable {
    let company: InfoText
    let number: InfoText
}

struct SubResult: Codable {
    let items: [Item]
}

struct Item: Codable {
    let name: InfoText
    let count: InfoText
    let price: Price
}

struct Price: Codable {
    let price: InfoText
    let unitPrice: InfoText
}

struct ValidationResult: Codable {
    let result: String
}
