//
//  RecipeViewModel.swift
//  sevenOclock
//
//  Created by Jiyoung Park on 2024/04/16.
//

import SwiftUI
import FirebaseFirestore

@MainActor
final class RecipeViewModel: ObservableObject {
    @Published private(set) var recipes: [Recipe] = []
    @Published var selectedSortOption = RecipeSortOption.byReview.rawValue
    
    private var lastDocument: DocumentSnapshot?
    private var selectedFilters: [String] = []
    
    func emptyRecipes() {
        self.recipes = []
        self.lastDocument = nil
    }
    
    func updateFilters(foods: [Food]?, searchTags: [String]) {
        selectedFilters = []
        if let foods {
            let subcategories: Set<String> = Set(foods.filter { ($0.subcategory != nil) && $0.subcategory != "기타" && $0.usebyDate!.daysLeft() < 3 }.map { $0.subcategory! })
            self.selectedFilters.append(contentsOf: Array(subcategories))
        }
        
        self.selectedFilters.append(contentsOf: searchTags)
        
        let unique = Set(selectedFilters)
        selectedFilters = Array(unique)
        
        print(selectedFilters)
    }

    func fetchRecipes() async throws {
        let (newRecipes, lastDocument) = try await RecipeManager.shared.fetchRecipes(ingredients: selectedFilters, searchBy: selectedSortOption, lastDocument: lastDocument)
        self.recipes.append(contentsOf: newRecipes)
        self.lastDocument = lastDocument
    }
}
