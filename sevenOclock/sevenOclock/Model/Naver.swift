//
//  Naver.swift
//  sevenOclock
//
//  Created by Jiyoung Park on 2024/04/30.
//

// MARK: - Naver
struct Naver: Codable {
    let version, requestID: String
    let timestamp: Int
    let images: [NaverImage]

    enum CodingKeys: String, CodingKey {
        case version
        case requestID = "requestId"
        case timestamp, images
    }
}

// MARK: - NaverImage
struct NaverImage: Codable {
    let format, name, data: String
}
