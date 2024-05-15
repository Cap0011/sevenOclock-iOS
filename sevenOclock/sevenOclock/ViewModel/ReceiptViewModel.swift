//
//  ReceiptViewModel.swift
//  sevenOclock
//
//  Created by Jiyoung Park on 2024/04/28.
//

import Foundation

class ReceiptViewModel: ObservableObject {
    @Published var items: [ReceiptItem] = []
    
    func parseReceiptResponse(jsonData: Data) {
//        print("JSON Data:", String(data: jsonData, encoding: .utf8) ?? "Unable to decode JSON data")
        do {
            let decoder = JSONDecoder()
            let response = try decoder.decode(ReceiptResponse.self, from: jsonData)
            // ReceiptResponse에서 items를 가져와서 ViewModel의 items에 할당
            let data = response.images?.first?.receipt?.result?.subResults?.flatMap { $0.items }.flatMap { $0 } ?? []
            self.items = []
            for item in data {
                self.items.append(ReceiptItem(id: UUID(), name: item.name?.text ?? "", count: Int(item.count?.text ?? "1") ?? 1))
            }
        } catch {
            print("Error parsing JSON: \(error)")
            debugPrint(error)
        }
    }
}
