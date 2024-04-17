//
//  RecipeViewModel.swift
//  sevenOclock
//
//  Created by Jiyoung Park on 2024/04/16.
//

import SwiftUI

@MainActor
final class RecipeViewModel: ObservableObject {
    @Published private(set) var recipes: [Recipe] = []
    
    func getAllRecipes() async throws {
        self.recipes = try await RecipeManager.shared.getAllRecipes()
    }
}
