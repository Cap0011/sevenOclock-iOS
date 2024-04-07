//
//  RecipeView.swift
//  sevenOclock
//
//  Created by Jiyoung Park on 2024/04/05.
//

import SwiftUI

struct RecipeView: View {
    @State private var searchTitle = ""
    @State private var isDateTagSelected = false
    @State private var selectedSortOption = "냉장고 일치 순"
    @State private var isShowingWebView = false
    @State private var selectedURL = ""
    
    @State private var recipes: [Recipe] = Recipe.dummyData
    
    @State private var tags: [String] = ["시금치", "베이컨"]
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    NavigationLink(destination: RecipeSearchView(tags: $tags)) {
                        searchBar
                            .padding(.top, 15)
                            .padding(.horizontal, 25)
                            .padding(.bottom, 10)
                    }
                    
                    filterSpace
                        .padding(.bottom, 10)
                    
                    Divider()
                        .padding(.bottom, 15)
                    
                    HStack {
                        Spacer()
                        
                        SelectionBar(selections: RecipeSortOption.allCasesStringArray(), selected: $selectedSortOption)
                    }
                    .padding(.horizontal, 20)
                    
                    recipeList
                        .padding(.top, 10)
                        .padding(.bottom, 30)
                }
            }
            .sheet(isPresented: $isShowingWebView) {
                WebView(url: selectedURL)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("취소") {
                                dismiss()
                            }
                        }
                    }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("레시피")
                        .font(.suite(.semibold, size: 17))
                }
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: SettingView()) {
                        Image(systemName: "gearshape.fill")
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .onChange(of: selectedURL) { _ in
                print(selectedURL)
            }
        }
    }
    
    var searchBar: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 17)
                .stroke(lineWidth: 1.5)
                .frame(height: 38)
            HStack {
                Image(systemName: "magnifyingglass")
                    .padding(.leading, 10)
                
                Text("검색할 재료, 레시피를 입력하세요")
            }
        }
        .foregroundStyle(.gray)
        .font(.suite(.regular, size: 15))
    }
    
    var filterSpace: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 8) {
                MyCapsule(isSelected: isDateTagSelected, textColour: isDateTagSelected ? .white : .red, colour: .red, text: "기한 임박 재료 포함")
                    .onTapGesture {
                        isDateTagSelected.toggle()
                    }
                
                ForEach(tags, id: \.self) { tag in
                    IngredientCapsule(title: tag)
                        .onTapGesture {
                            tags = tags.filter { $0 != tag }
                        }
                }
            }
            .frame(height: 38)
            .padding(.horizontal, 25)
        }
    }
    
    var recipeList: some View {
        VStack(spacing: 15) {
            ForEach(recipes, id: \.id) { recipe in
                RecipeCard(recipe: recipe)
                    .onTapGesture {
                        Task {
                            selectedURL = recipe.link
                            isShowingWebView.toggle()
                        }
                    }
            }
        }
        .padding(.horizontal, 20)
    }
    
    struct RecipeCard: View {
        let recipe: Recipe
        
        var body: some View {
            HStack(spacing: 10) {
                ZStack(alignment: .topTrailing) {
                    if let url = URL(string: recipe.imageURL) {
                        AsyncImage(url: url) { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 5))
                        } placeholder: {
                            RoundedRectangle(cornerRadius: 5)
                                .frame(width: 100, height: 100)
                                .foregroundStyle(.grey1)
                        }
                    } else {
                        RoundedRectangle(cornerRadius: 5)
                            .frame(width: 100, height: 100)
                            .foregroundStyle(.grey1)
                    }
                    
                    IngredientCircle
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    Text(recipe.name)
                        .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                        .font(.suite(.semibold, size: 14))
                        .padding(.bottom, 5)
                
                    HStack(spacing: 0) {
                        Text("조회수 ")
                            .font(.suite(.medium, size: 11))
                        Text("\(recipe.viewNumber)")
                            .font(.suite(.light, size: 11))
                        Text(" · 리뷰 ")
                            .font(.suite(.medium, size: 11))
                        Text("\(recipe.reviewNumber)")
                            .font(.suite(.light, size: 11))
                    }
                    .foregroundStyle(.grey0.opacity(0.8))
                    
                    HStack(spacing: 5) {
                        Spacer()
                        
                        Image(systemName: "xmark.circle.fill")
                            
                        Text("옥수수, 베이컨")
                            .lineLimit(1)
                            .padding(4)
                            .padding(.horizontal, 2)
                            .background(RoundedRectangle(cornerRadius: 4).foregroundStyle(.white))
                            .font(.suite(.regular, size: 13))
                    }
                    .foregroundStyle(.recipeOrange)
                    .padding(.top, 10)
                }
                
                Spacer()
            }
            .padding(10)
            .background(RoundedRectangle(cornerRadius: 5.0).foregroundStyle(.backgroundOrange).shadow(color: .black.opacity(0.1), radius: 8, x: 4.0, y: 4.0))
        }
        
        var IngredientCircle: some View {
            ZStack {
                Circle()
                    .foregroundStyle(.white)
                    .frame(width: 36, height: 36)
                    .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
                
                Circle()
                    .trim(from: 0.0, to: CGFloat(Double(recipe.similarity ?? 0) * 0.01))
                    .foregroundStyle(.circleOrange)
                    .frame(width: 32, height: 32)
                    .rotationEffect(.degrees(-90))
                
                Circle()
                    .foregroundStyle(.white)
                    .frame(width: 28, height: 28)
                
                Text("3 / \(recipe.ingredients.count)")
                    .font(.suite(.bold, size: 11))
            }
            .padding(5)
        }
    }
}

#Preview {
    RecipeView()
}
