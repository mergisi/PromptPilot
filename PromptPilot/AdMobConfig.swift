//
//  AdMobConfig.swift
//  PromptPilot
//
//  Created by AI Assistant on 9/15/25.
//

import Foundation

struct AdMobConfiguration {
    // MARK: - Configuration
    // TODO: Replace with your actual AdMob Ad Unit IDs from https://admob.google.com
    // NOTE: This is currently an APP ID (ends with ~), you need AD UNIT ID (ends with /)
    static let bannerAdUnitID = "ca-app-pub-3940256099942544/2934735716" // Google TEST Ad Unit ID - for testing only!
    
    // Your App ID (for Info.plist): ca-app-pub-5223337070047795~9361812948
    
    // Optional: Different ad units for different placements
    static let homeTabBannerID = "xxxxxxxx" // Optional: specific for home tab
    static let favoritesTabBannerID = "xxxxxxxx" // Optional: specific for favorites tab
    static let learnTabBannerID = "xxxxxxxx" // Optional: specific for learn tab
    
    // Test Ad Unit IDs (Google's official test IDs)
    static let testBannerAdUnitID = "ca-app-pub-5223337070047795~9361812948"
    
    // MARK: - Ad Unit Selection
    static var primaryBannerAdUnitID: String {
        #if DEBUG
        return testBannerAdUnitID // Always use test ads in debug builds
        #else
        return bannerAdUnitID.isEmpty || bannerAdUnitID == "xxxxxxxx" ? testBannerAdUnitID : bannerAdUnitID
        #endif
    }
    
    // MARK: - Ad Display Rules
    static let showAdsForPremiumUsers = false // Set to true if you want to show ads to premium users too
    static let adRefreshInterval: TimeInterval = 30 // Seconds between ad refreshes (optional)
    
    // MARK: - Instructions
    /*
     To set up AdMob:
     
     1. Sign up for Google AdMob at https://admob.google.com
     2. Create a new app or add existing app
     3. Create ad units for your app:
        - Go to "Ad units" in your app
        - Create "Banner" ad unit
        - Copy the Ad Unit ID (format: ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX)
     4. Replace "xxxxxxxx" above with your actual Ad Unit ID
     5. Add your App ID to Info.plist (see setup instructions below)
     
     Example Ad Unit ID:
     static let bannerAdUnitID = "ca-app-pub-1234567890123456/1234567890"
     
     Info.plist Setup:
     Add this key-value pair to your Info.plist:
     <key>GADApplicationIdentifier</key>
     <string>ca-app-pub-XXXXXXXXXXXXXXXX~XXXXXXXXXX</string>
     
     Note: App ID is different from Ad Unit ID. App ID ends with ~, Ad Unit ID ends with /
     */
}
