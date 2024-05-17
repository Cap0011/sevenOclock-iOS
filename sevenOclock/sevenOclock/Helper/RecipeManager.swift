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
    
    private let recipeCollection = Firestore.firestore().collection("recipe")

    func fetchRecipes(ingredients: [String], searchBy: String, lastDocument: DocumentSnapshot?) async throws -> (recipes: [Recipe], lastDocument: DocumentSnapshot?) {
        if !ingredients.isEmpty {
            if let lastDocument {
                switch searchBy {
                case RecipeSortOption.byReview.rawValue:
                    return try await recipeCollection
                        .whereField("ingredients", arrayContainsAny: ingredients)
                        .order(by: "reviewNumber", descending: true)
                        .limit(to: 10)
                        .start(afterDocument: lastDocument)
                        .getDocumentsWithSnapshot(as: Recipe.self)
                case RecipeSortOption.byView.rawValue:
                    return try await recipeCollection
                        .whereField("ingredients", arrayContainsAny: ingredients)
                        .order(by: "viewNumber", descending: true)
                        .limit(to: 10)
                        .start(afterDocument: lastDocument)
                        .getDocumentsWithSnapshot(as: Recipe.self)
                default:
                    return ([], nil)
                }
            } else {
                switch searchBy {
                case RecipeSortOption.byReview.rawValue:
                    return try await recipeCollection
                        .whereField("ingredients", arrayContainsAny: ingredients)
                        .order(by: "reviewNumber", descending: true)
                        .limit(to: 10)
                        .getDocumentsWithSnapshot(as: Recipe.self)
                case RecipeSortOption.byView.rawValue:
                    return try await recipeCollection
                        .whereField("ingredients", arrayContainsAny: ingredients)
                        .order(by: "viewNumber", descending: true)
                        .limit(to: 10)
                        .getDocumentsWithSnapshot(as: Recipe.self)
                default:
                    return ([], nil)
                }
            }
        } else {
            if let lastDocument {
                switch searchBy {
                case RecipeSortOption.byReview.rawValue:
                    return try await recipeCollection
                        .order(by: "reviewNumber", descending: true)
                        .limit(to: 10)
                        .start(afterDocument: lastDocument)
                        .getDocumentsWithSnapshot(as: Recipe.self)
                case RecipeSortOption.byView.rawValue:
                    return try await recipeCollection
                        .order(by: "viewNumber", descending: true)
                        .limit(to: 10)
                        .start(afterDocument: lastDocument)
                        .getDocumentsWithSnapshot(as: Recipe.self)
                default:
                    return ([], nil)
                }
            } else {
                switch searchBy {
                case RecipeSortOption.byReview.rawValue:
                    return try await recipeCollection
                        .order(by: "reviewNumber", descending: true)
                        .limit(to: 10)
                        .getDocumentsWithSnapshot(as: Recipe.self)
                case RecipeSortOption.byView.rawValue:
                    return try await recipeCollection
                        .order(by: "viewNumber", descending: true)
                        .limit(to: 10)
                        .getDocumentsWithSnapshot(as: Recipe.self)
                default:
                    return ([], nil)
                }
            }
        }
    }
}

extension Query {
    func getDocuments<T>(as type: T.Type) async throws -> [T] where T : Decodable {
        try await getDocumentsWithSnapshot(as: type).recipes
    }
    
    func getDocumentsWithSnapshot<T>(as type: T.Type) async throws -> (recipes: [T], lastDocument: DocumentSnapshot?) where T : Decodable {
        let snapshot = try await self.getDocuments()
        
        let recipes = try snapshot.documents.compactMap { document in
            try document.data(as: T.self)
        }
        return (recipes, snapshot.documents.last)
    }
}
