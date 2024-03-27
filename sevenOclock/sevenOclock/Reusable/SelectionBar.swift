//
//  SelectionBar.swift
//  sevenOclock
//
//  Created by Jiyoung Park on 2024/03/27.
//

import SwiftUI

struct SelectionBar: View {
    let selections: [SortOption]
    @Binding var selected: SortOption
    
    var body: some View {
        Menu {
            Picker("Sort By", selection: $selected) {
                ForEach(selections, id: \.self) {
                    Text($0.rawValue)
                }
            }
        } label: {
            HStack(spacing: 10) {
                Text(selected.rawValue)
                    .font(.suite(.medium, size: 13))
                Image(systemName: "chevron.down")
            }
            .padding(.leading, 15)
            .padding(.trailing, 10)
            .background(RoundedRectangle(cornerRadius: 15).stroke(lineWidth: 1.0).frame(height: 30))
            .foregroundStyle(.gray)
        }
    }
}

#Preview {
    SelectionBar(selections: SortOption.allCases, selected: .constant(SortOption.byDateDESC))
}
