//
//  RecipeManager.swift
//  sevenOclock
//
//  Created by Jiyoung Park on 2024/04/16.
//

import Foundation
import FirebaseFirestore

final class RecipeManager: ObservableObject {
    static let shared = RecipeManager()
    private init() { }
    
    private let recipeCollection = Firestore.firestore().collection("recipes")
    
    func getAllRecipes() async throws -> [Recipe] {
        return try await recipeCollection
            .limit(to: 20)
            .getDocuments(as: Recipe.self)
    }
    
    func fetchRecipes(ingredients: [String]?, searchBy: String) async throws -> [Recipe] {
        try await recipeCollection.getDocuments(as: Recipe.self)
    }
}

extension Query {
    func getDocuments<T>(as type: T.Type) async throws -> [T] where T : Decodable {
        let snapshot = try await self.getDocuments()
        
        return try snapshot.documents.compactMap { document in
            try document.data(as: T.self)
        }
    }
}
