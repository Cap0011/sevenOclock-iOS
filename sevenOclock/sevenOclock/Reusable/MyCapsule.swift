//
//  MyCapsule.swift
//  sevenOclock
//
//  Created by Jiyoung Park on 2024/03/26.
//

import SwiftUI

struct MyCapsule: View {
    let isSelected: Bool
    
    let textColour: Color
    let colour: Color
    let text: String
    
    var body: some View {
        ZStack {
            if isSelected {
                Text(text)
                    .foregroundStyle(textColour)
                    .padding(.horizontal, 18)
                    .background(RoundedRectangle(cornerRadius: 17).frame(height: 30).foregroundStyle(colour))
            } else {
                Text(text)
                    .foregroundStyle(textColour)
                    .padding(.horizontal, 18)
                    .background(RoundedRectangle(cornerRadius: 17).stroke(lineWidth: 1.5).frame(height: 30).foregroundStyle(colour))
            }
        }
        .font(.suite(.medium, size: 14))
    }
}

#Preview {
    MyCapsule(isSelected: false, textColour: .gray, colour: .gray, text: "전체")
}
