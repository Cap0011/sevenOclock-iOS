//
//  FoodItem.swift
//  sevenOclock
//
//  Created by Jiyoung Park on 2024/03/27.
//

import SwiftUI

struct FoodItem: View {
    let item: Food
    let date: Date
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 0) {
                Image(Category.fromRawValue(rawValue: item.category ?? "기타")?.imageName() ?? "others")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 70, height: 70)
                    .padding(.top, 10)
                    .padding(.bottom, 3)
                
                HStack(spacing: 0) {
                    Text("\(item.name ?? "")")
                        .lineLimit(1)
                    
                    Text(" \(item.count)")
                }
                .font(.suite(.medium, size: 13))
                .foregroundStyle(.black)
                .padding(.bottom, 3)
                
                HStack(spacing: 0) {
                    Text(date.formattedString(format: "YYYY.MM.dd"))
                        .foregroundStyle(date.daysLeft() > 3 ? .gray : .red)
                    Text(" 까지")
                }
                    
            }
            .font(.suite(.regular, size: 10))
            .padding(10)
            .foregroundStyle(.gray)
            .background(RoundedRectangle(cornerRadius: 10.0).foregroundStyle(.white).shadow(color: .black.opacity(0.25), radius: 8, x: 2.0, y: 2.0))
            
            DayTag(date: date)
                .padding(7)
        }
    }
    
    struct DayTag: View {
        let date: Date
        
        var body: some View {
            Text(date.daysLeft() < 0 ? "D+\(date.daysLeft()*(-1))" : "D-\(date.daysLeft())")
                .font(.suite(.bold, size: 12))
                .foregroundStyle(.white)
                .padding(.vertical, 5)
                .padding(.horizontal, 8)
                .background(RoundedRectangle(cornerRadius: 10.0).frame(height: 20).foregroundStyle(properColour()))
                .opacity(0.8)
        }
        
        private func properColour() -> Color {
            if date.daysLeft() >= 7 {
                return .green
            } else if date.daysLeft() <= 3 {
                return .red
            } else {
                return .orange
            }
        }
    }
}
