//
//  PromptPilotApp.swift
//  PromptPilot
//
//  Created by mustafa ergisi on 8/4/25.
//

import SwiftUI
import Clarity

@main
struct PromptPilotApp: App {
    let persistenceController = PersistenceController.shared
    
    init() {
        // Initialize Microsoft Clarity
        let clarityConfig = ClarityConfig(projectId: "st8n2ykz1w")
        ClaritySDK.initialize(config: clarityConfig)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
