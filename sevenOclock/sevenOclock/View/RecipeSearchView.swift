//
//  RecipeSearchView.swift
//  sevenOclock
//
//  Created by Jiyoung Park on 2024/04/06.
//

import SwiftUI

struct RecipeSearchView: View {
    @Binding var tags: [String]
    
    @State var newTags: [String] = []
    @State var searchTitle = ""
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(alignment: .leading) {
            SearchBar(placeholder: "검색할 재료, 레시피를 입력하세요", searchTitle: $searchTitle)
                .padding(.horizontal, 25)
                .padding(.top, 15)
            
            Text("2가지 이상의 재료는 띄어쓰기로 구분해 주세요")
                .font(.suite(.regular, size: 13))
                .foregroundStyle(.grey0)
                .padding(.horizontal, 30)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(newTags, id: \.self) { tag in
                        IngredientCapsule(title: tag)
                            .onTapGesture {
                                newTags = newTags.filter { $0 != tag }
                            }
                    }
                }
                .frame(height: 38)
                .padding(.horizontal, 25)
            }
            .padding(.top, 5)
            
            Spacer()
        }
        .onChange(of: searchTitle) { title in
            if title.last == " " {
                newTags.append(String(title.dropLast()))
                searchTitle = ""
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                HStack {
                    Image(systemName: "chevron.backward")
                    Text("취소")
                }
                .font(.suite(.regular, size: 16))
                .onTapGesture {
                    dismiss()
                }
            }
            ToolbarItem(placement: .principal) {
                Text("레시피")
                    .font(.suite(.semibold, size: 17))
            }
            ToolbarItem(placement: .topBarTrailing) {
                Text("완료")
                    .font(.suite(.bold, size: 16))
                    .onTapGesture {
                        tags.append(contentsOf: newTags)
                        dismiss()
                    }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    RecipeSearchView(tags: .constant([]))
}
