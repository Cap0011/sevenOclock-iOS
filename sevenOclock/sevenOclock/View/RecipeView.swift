//
//  RecipeView.swift
//  sevenOclock
//
//  Created by Jiyoung Park on 2024/04/05.
//

import SwiftUI
import AlertToast

struct RecipeView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @FetchRequest(entity: Food.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Food.usebyDate, ascending: true)]) var foods: FetchedResults<Food>
    
    @State private var searchTitle = ""
    @State private var isDateTagSelected = false
    
    @State private var isShowingWebView = false
    @State private var selectedURL = ""
    
    @StateObject private var viewModel = RecipeViewModel()
    
    @State private var tags: [String] = []
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var filteredRecipes = [Recipe]()
    
    @State var isShowingToast = false
    
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
                        
                        SelectionBar(selections: RecipeSortOption.allCasesStringArray(), selected: $viewModel.selectedSortOption)
                    }
                    .padding(.horizontal, 20)
                    
                    recipeList
                        .padding(.top, 10)
                        .padding(.bottom, 30)
                }
            }
            .sheet(isPresented: $isShowingWebView) {
                WebViewContainer(url: selectedURL)
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
        }
        .task {
            try? await viewModel.fetchRecipes()
        }
        .toast(isPresenting: $isShowingToast){
            AlertToast(displayMode: .banner(.slide), type: .error(.red), title: "기한 임박 식품이 없습니다.", style: .style(backgroundColor: .lightBlue, titleColor: .black, subTitleColor: .black))
        }
        .onChange(of: viewModel.selectedSortOption) {
            Task {
                viewModel.emptyRecipes()
                try? await viewModel.fetchRecipes()
            }
        }
        .onChange(of: isDateTagSelected) {
            print(getUrgentIngredients())
            if tags.isEmpty {
                if getUrgentIngredients().count > 0 {
                    Task {
                        viewModel.updateFilters(foods: isDateTagSelected ? getUrgentIngredients() : nil, searchTags: tags)
                        viewModel.emptyRecipes()
                        try? await viewModel.fetchRecipes()
                    }
                } else if isDateTagSelected {
                    isDateTagSelected = false
                    isShowingToast.toggle()
                }
            } else {
                if getUrgentIngredients().count > 0 {
                    filterRecipes()
                } else if isDateTagSelected {
                    isDateTagSelected = false
                    isShowingToast.toggle()
                }
            }
        }
        .onChange(of: tags.count) {
            Task {
                viewModel.updateFilters(foods: nil, searchTags: tags)
                viewModel.emptyRecipes()
                try? await viewModel.fetchRecipes()
            }
        }
        .onChange(of: viewModel.recipes) {
            filterRecipes()
        }
    }
    
    var searchBar: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 17)
                .stroke(lineWidth: 1.5)
                .frame(height: 38)
                .foregroundStyle(.grey0.opacity(0.3))
            
            HStack {
                Image(systemName: "magnifyingglass")
                    .padding(.leading, 10)
                    .opacity(0.8)
                
                Text("검색할 재료를 입력하세요")
            }
        }
        .foregroundStyle(.grey0.opacity(0.8))
        .font(.suite(.regular, size: 15))
    }
    
    var filterSpace: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 8) {
                MyCapsule(isSelected: isDateTagSelected, textColour: isDateTagSelected ? .white : .tagRed, colour: .tagRed, text: "기한 임박 재료 포함")
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
        LazyVStack(spacing: 15) {
            ForEach(filteredRecipes, id: \.ID) { recipe in
                VStack {
                    RecipeCard(recipe: recipe, missingIngredients: getMissingIngredients(ingredients: recipe.ingredients))
                        .onTapGesture {
                            Task {
                                selectedURL = recipe.link
                                isShowingWebView.toggle()
                            }
                        }
                    
                    if recipe.ID == filteredRecipes.last?.ID {
                        ProgressView()
                            .onAppear {
                                Task {
                                    try await viewModel.fetchRecipes()
                                }
                            }
                    }
                }
            }
        }
        .padding(.horizontal, 20)
    }
    
    struct RecipeCard: View {
        let recipe: Recipe
        let missingIngredients: [String]
        
        var body: some View {
            HStack(alignment: .bottom, spacing: 10) {
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
                        
                        if missingIngredients.count > 0 {
                            Image(systemName: "xmark.circle.fill")
                            
                            Text(missingIngredients.joined(separator: ", "))
                                .lineLimit(1)
                                .padding(4)
                                .padding(.horizontal, 2)
                                .background(RoundedRectangle(cornerRadius: 4).foregroundStyle(.white))
                                .font(.suite(.regular, size: 13))
                        }
                    }
                    .foregroundStyle(.recipeOrange)
                    .padding(.top, 10)
                    .padding(.bottom, 5)
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
                
                if recipe.ingredients.count > 0 && missingIngredients.count != recipe.ingredients.count {
                    Circle()
                        .trim(from: 0.0, to: 1 - Double(missingIngredients.count) / Double(recipe.ingredients.count))
                        .foregroundStyle(.circleOrange)
                        .frame(width: 32, height: 32)
                        .rotationEffect(.degrees(-90))
                }
                
                Circle()
                    .foregroundStyle(.white)
                    .frame(width: 28, height: 28)
                
                Text("\(recipe.ingredients.count - missingIngredients.count) / \(recipe.ingredients.count)")
                    .font(.suite(.bold, size: 11))
            }
            .padding(5)
        }
    }
    
    func getMissingIngredients(ingredients: [String]) -> [String] {
        let subcategories = Array(Set(foods.map { $0.subcategory }))
        return ingredients.filter { ingredient in
            return !subcategories.contains { subcategory in
                return ingredient.contains(subcategory ?? "N/A")
            }
        }
    }
    
    func filterRecipes() {
        filteredRecipes = viewModel.recipes
        
        if !tags.isEmpty && isDateTagSelected {
            let myIngredients = foods.filter({$0.subcategory != "기타" && $0.subcategory != nil}).map({$0.subcategory})
            
            filteredRecipes = viewModel.recipes.filter{
                for ingredient in myIngredients {
                    return $0.ingredients.contains(ingredient!)
                }
                return false
            }
        }
    }
    
    func getUrgentIngredients() -> [Food] {
        return foods.filter { ($0.subcategory != nil) && $0.subcategory != "기타" && $0.usebyDate!.daysLeft() <= 3 }
    }
}

#Preview {
    RecipeView()
}
