//
//  IngredientCapsule.swift
//  sevenOclock
//
//  Created by Jiyoung Park on 2024/04/06.
//

import SwiftUI

struct IngredientCapsule: View {
    let title: String
    
    var body: some View {
        HStack(spacing: 5) {
            Text(title)
            
            Image(systemName: "xmark")
        }
        .padding(.horizontal, 10)
        .foregroundStyle(.white)
        .font(.suite(.regular, size: 13))
        .background(RoundedRectangle(cornerRadius: 15.0).foregroundStyle(.grey0).frame(height: 30))
    }
}

#Preview {
    IngredientCapsule(title: "시금치")
}
