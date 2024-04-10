//
//  FoodListView.swift
//  sevenOclock
//
//  Created by Jiyoung Park on 2024/04/11.
//

import SwiftUI

struct FoodListView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var foods: [Food]
    
    let layout = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
            
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: layout) {
                    ForEach(foods, id: \.id) { food in
                        FoodItem(item: food, date: food.usebyDate ?? Date())
                            .padding(.top, 10)
                            .padding(.bottom, 5)
                    }
                    Spacer()
                }
                .padding(.top, 5)
                .padding(.bottom, 15)
                .padding(.horizontal, 15)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("식품 목록")
                        .font(.suite(.semibold, size: 17))
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Text("닫기")
                        .font(.suite(.bold, size: 16))
                        .onTapGesture {
                            dismiss()
                        }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
        }
    }
}
