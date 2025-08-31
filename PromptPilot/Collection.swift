//
//  Collection.swift
//  PromptPilot
//
//  Created by PromptPilot AI Assistant on 8/4/25.
//

import Foundation

// MARK: - Collection Model
struct Collection: Identifiable, Codable {
    let id: UUID
    var name: String
    var description: String
    var promptIds: [UUID]
    var color: String // For visual distinction
    let createdAt: Date
    
    init(id: UUID = UUID(), name: String, description: String, color: String = "pilotBlue") {
        self.id = id
        self.name = name
        self.description = description
        self.promptIds = []
        self.color = color
        self.createdAt = Date()
    }
}

// MARK: - Sample Collections
extension Collection {
    static var sampleCollections: [Collection] = [
        Collection(
            name: "Startup Essentials",
            description: "Key prompts for launching your startup",
            color: "pilotBlue"
        ),
        Collection(
            name: "Content Creator Kit",
            description: "Everything you need for social media and blogging",
            color: "lightBlue"
        ),
        Collection(
            name: "Developer Tools",
            description: "Code review, debugging, and documentation prompts",
            color: "pilotBlue"
        )
    ]
}