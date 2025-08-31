//
//  PromptStore.swift
//  PromptPilot
//
//  Created by PromptPilot AI Assistant on 8/4/25.
//

import Foundation
import SwiftUI

// MARK: - Prompt Store
class PromptStore: ObservableObject {
    @Published var prompts: [Prompt] = []
    @Published var collections: [Collection] = []
    
    static let shared = PromptStore()
    
    private let promptsKey = "SavedPrompts"
    private let collectionsKey = "SavedCollections"
    private let hasInitializedKey = "HasInitializedData"
    private let samplePromptsVersionKey = "SamplePromptsVersion"
    private let currentSamplePromptsVersion = 2 // Increment this when adding new sample prompts
    
    private init() {
        loadData()
    }
    
    func toggleFavorite(for promptId: UUID) {
        if let index = prompts.firstIndex(where: { $0.id == promptId }) {
            prompts[index].isFavorite.toggle()
            saveData()
        }
    }
    
    func isFavorite(promptId: UUID) -> Bool {
        prompts.first(where: { $0.id == promptId })?.isFavorite ?? false
    }
    
    func getFavoritePrompts() -> [Prompt] {
        prompts.filter { $0.isFavorite }
    }
    
    func getPrompt(by id: UUID) -> Prompt? {
        prompts.first(where: { $0.id == id })
    }
    
    func addToCollection(_ collectionId: UUID, promptId: UUID) {
        if let index = collections.firstIndex(where: { $0.id == collectionId }) {
            if !collections[index].promptIds.contains(promptId) {
                collections[index].promptIds.append(promptId)
                saveData()
            }
        }
    }
    
    func removeFromCollection(_ collectionId: UUID, promptId: UUID) {
        if let index = collections.firstIndex(where: { $0.id == collectionId }) {
            collections[index].promptIds.removeAll { $0 == promptId }
            saveData()
        }
    }
    
    func createCollection(name: String, description: String) {
        let newCollection = Collection(name: name, description: description)
        collections.append(newCollection)
        saveData()
    }
    
    func deleteCollection(_ collectionId: UUID) {
        collections.removeAll { $0.id == collectionId }
        saveData()
    }
    
    // MARK: - Persistence
    private func saveData() {
        // Save prompts
        if let encoded = try? JSONEncoder().encode(prompts) {
            UserDefaults.standard.set(encoded, forKey: promptsKey)
        }
        
        // Save collections
        if let encoded = try? JSONEncoder().encode(collections) {
            UserDefaults.standard.set(encoded, forKey: collectionsKey)
        }
    }
    
    private func loadData() {
        // Check if this is first launch or if sample prompts have been updated
        let hasInitialized = UserDefaults.standard.bool(forKey: hasInitializedKey)
        let savedVersion = UserDefaults.standard.integer(forKey: samplePromptsVersionKey)
        
        if !hasInitialized || savedVersion < currentSamplePromptsVersion {
            // First launch or sample prompts updated - load new sample data
            prompts = Prompt.samplePrompts
            collections = Collection.sampleCollections
            UserDefaults.standard.set(true, forKey: hasInitializedKey)
            UserDefaults.standard.set(currentSamplePromptsVersion, forKey: samplePromptsVersionKey)
            saveData()
        } else {
            // Load saved prompts
            if let data = UserDefaults.standard.data(forKey: promptsKey),
               let decoded = try? JSONDecoder().decode([Prompt].self, from: data) {
                prompts = decoded
            } else {
                // Fallback to sample prompts if loading fails
                prompts = Prompt.samplePrompts
            }
            
            // Load saved collections
            if let data = UserDefaults.standard.data(forKey: collectionsKey),
               let decoded = try? JSONDecoder().decode([Collection].self, from: data) {
                collections = decoded
            } else {
                // Fallback to sample collections if loading fails
                collections = Collection.sampleCollections
            }
        }
    }
    
    func resetToDefaults() {
        prompts = Prompt.samplePrompts
        collections = Collection.sampleCollections
        saveData()
    }
    
    func forceReloadSamplePrompts() {
        // This method forces a reload of the latest sample prompts
        prompts = Prompt.samplePrompts
        collections = Collection.sampleCollections
        UserDefaults.standard.set(currentSamplePromptsVersion, forKey: samplePromptsVersionKey)
        saveData()
    }
}