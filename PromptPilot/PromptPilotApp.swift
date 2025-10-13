//
//  PromptPilotApp.swift
//  PromptPilot
//
//  Created by mustafa ergisi on 8/4/25.
//

import SwiftUI
import Clarity
// import GoogleMobileAds // TODO: Add back when GoogleMobileAds package is resolved

@main
struct PromptPilotApp: App {
    let persistenceController = PersistenceController.shared
    
    init() {
        // Initialize Microsoft Clarity
        let clarityConfig = ClarityConfig(projectId: "st8n2ykz1w")
        ClaritySDK.initialize(config: clarityConfig)
        
        // Initialize Google Mobile Ads SDK
        // GADMobileAds.sharedInstance().start(completionHandler: nil) // TODO: Uncomment when GoogleMobileAds is added
        
        // Track app launch
        MixpanelManager.shared.trackAppLaunched()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(PremiumManager.shared)
        }
    }
}
