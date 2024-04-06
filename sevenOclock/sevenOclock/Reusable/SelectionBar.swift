//
//  SelectionBar.swift
//  sevenOclock
//
//  Created by Jiyoung Park on 2024/03/27.
//

import SwiftUI

struct SelectionBar: View {
    let selections: [String]
    @Binding var selected: String
    
    var body: some View {
        Menu {
            Picker("Sort By", selection: $selected) {
                ForEach(selections, id: \.self) {
                    Text($0)
                }
            }
        } label: {
            HStack(spacing: 10) {
                Text(selected)
                    .font(.suite(.medium, size: 15))
                Image(systemName: "chevron.down")
            }
            .foregroundStyle(.grey0)
            .padding(.leading, 15)
            .padding(.trailing, 10)
            .background(RoundedRectangle(cornerRadius: 15).stroke(lineWidth: 1.0).frame(height: 34).foregroundColor(.grey0).opacity(0.3).background(RoundedRectangle(cornerRadius: 15).foregroundStyle(.white)))
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    SelectionBar(selections: SortOption.allCasesStringArray(), selected: .constant(SortOption.byDateDESC.rawValue))
}
