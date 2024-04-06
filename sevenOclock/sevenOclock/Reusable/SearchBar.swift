//
//  SearchBar.swift
//  sevenOclock
//
//  Created by Jiyoung Park on 2024/03/26.
//

import SwiftUI

struct SearchBar: View {
    var placeholder = "검색할 식품 이름을 입력하세요"
    
    @FocusState private var isFocused: Bool
    
    @Binding var searchTitle: String
    @State var isSearching = false
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 17)
                .stroke(lineWidth: 1.5)
                .frame(height: 38)
            HStack {
                Image(systemName: "magnifyingglass")
                    .padding(.leading, 10)
                
                ZStack(alignment: .leading) {
                    if searchTitle.isEmpty  {
                        Text(placeholder)
                    }
                    
                    TextField("", text: $searchTitle) { startedEditing in
                        if startedEditing {
                            isFocused = true
                            withAnimation {
                                isSearching = true
                            }
                        }
                    } onCommit: {
                        isFocused = false
                        withAnimation {
                            isSearching = false
                        }
                    }
                    .focused($isFocused)
                }
                
                if isFocused {
                    Image(systemName: "xmark.circle.fill")
                        .onTapGesture {
                            searchTitle = ""
                            isFocused = false
                            withAnimation {
                                isSearching = false
                                UIApplication.shared.dismissKeyboard()
                            }
                        }
                        .padding(.trailing, 10)
                }
            }
        }
        .foregroundStyle(.gray)
        .font(.suite(.regular, size: 15))
    }
}

#Preview {
    SearchBar(searchTitle: .constant(""))
}
