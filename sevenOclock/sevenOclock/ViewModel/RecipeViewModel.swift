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
    @Published var selectedFilters: [String]?
    @Published var selectedSortOption = RecipeSortOption.byReview.rawValue
    
    private var lastDocument: DocumentSnapshot?
    
    func emptyRecipes() {
        self.recipes = []
        self.lastDocument = nil
    }

    func fetchRecipes() async throws {
        let (newRecipes, lastDocument) = try await RecipeManager.shared.fetchRecipes(ingredients: selectedFilters, searchBy: selectedSortOption, lastDocument: lastDocument)
        self.recipes.append(contentsOf: newRecipes)
        self.lastDocument = lastDocument
    }
}
