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
                Image(item.category ?? "기타")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 70)
                    .padding(.bottom, 10)
                
                Text("\(item.name ?? "") \(item.count)")
                    .font(.suite(.medium, size: 13))
                    .foregroundStyle(.black)
                    .padding(.bottom, 3)
                
                HStack(spacing: 0) {
                    Text(date.formattedString(format: "YYYY.MM.dd"))
                        .foregroundStyle(Int(date.daysLeft())! > 3 ? .gray : .red)
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
            Text("D-\(date.daysLeft())")
                .font(.suite(.bold, size: 12))
                .foregroundStyle(.white)
                .padding(.vertical, 5)
                .padding(.horizontal, 8)
                .background(RoundedRectangle(cornerRadius: 10.0).frame(height: 20).foregroundStyle(Int(date.daysLeft())! > 3 ? .gray : .tagRed))
                .opacity(0.8)
        }
    }
}
