//
//  CheckItemView.swift
//  sevenOclock
//
//  Created by Jiyoung Park on 2024/04/29.
//

import SwiftUI

struct CheckItemView: View {
    @Environment(\.dismiss) private var dismiss
    
    let items: [ReceiptItem]
    @Binding var foodList: [TemporaryFood]
    @Binding var isShowingAddSheet: Bool

    @State private var selectedItems: [UUID] = []
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 0) {
                        Text("이름")
                            .padding(.leading, 20)
                        Spacer()
                        Text("수량")
                    }
                    .padding(.leading, 20)
                    .padding(.horizontal, 50)
                    .font(.suite(.semibold, size: 16))
                    
                    Divider()
                        .padding(.top, 15)
                    
                    ForEach(items, id: \.id) { item in
                        HStack(spacing: 15) {
                            ZStack {
                                if selectedItems.contains(item.id) {
                                    Image(systemName: "checkmark.square.fill")
                                        .foregroundStyle(.green)
                                        .onTapGesture {
                                            selectedItems = selectedItems.filter { $0 != item.id }
                                        }
                                } else {
                                    Image(systemName: "checkmark.square")
                                        .foregroundStyle(.gray)
                                        .onTapGesture {
                                            selectedItems.append(item.id)
                                        }
                                }
                            }
                            Text(item.name)
                                .font(.suite(.medium, size: 15))
                            Spacer()
                            Text("\(item.count)")
                                .padding(.trailing, 58)
                                .font(.suite(.medium, size: 15))
                        }
                        .padding(.top, 20)
                        .foregroundStyle(selectedItems.contains(item.id) ? .black : .gray)
                    }
                }
                .padding(20)
            }
            .background(.lightBlue)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("취소")
                        .font(.suite(.regular, size: 16))
                        .onTapGesture {
                            dismiss()
                        }
                }
                ToolbarItem(placement: .principal) {
                    Text("영수증 목록")
                        .font(.suite(.semibold, size: 17))
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Text("완료")
                        .font(.suite(.bold, size: 16))
                        .onTapGesture {
                            if !selectedItems.isEmpty {
                                Task {
                                    selectedTemporaryFoods()
                                    dismiss()
                                    isShowingAddSheet.toggle()
                                }
                            } else {
                                // TODO: Exception Handling
                                print("selectedItems empty!")
                            }
                        }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
        }
    }
    
    private func selectedTemporaryFoods() {
        var result = [TemporaryFood]()
        let selectedList = items.filter { selectedItems.contains($0.id) }
        for item in selectedList {
            result.append(TemporaryFood(id: item.id, name: item.name, count: item.count))
        }
        foodList = result
    }
}

#Preview {
    CheckItemView(items: [], foodList: .constant([]), isShowingAddSheet: .constant(false))
}
