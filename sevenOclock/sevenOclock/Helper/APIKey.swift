//
//  APIKey.swift
//  sevenOclock
//

import Foundation

enum APIKey {
    static let receiptURL = Bundle.main.object(forInfoDictionaryKey: "ReceiptAPIURL") as? String ?? ""
    static let receiptKey = Bundle.main.object(forInfoDictionaryKey: "ReceiptAPIKey") as? String ?? ""
    static let barcodeKey = Bundle.main.object(forInfoDictionaryKey: "BarcodeAPIKey") as? String ?? ""
}
