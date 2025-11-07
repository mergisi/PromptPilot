//
//  AdMobConfig.swift
//  PromptPilot
//
//  Created by AI Assistant on 9/15/25.
//

import Foundation

struct AdMobConfiguration {
    // MARK: - Configuration
    // Your App ID (for Info.plist - ends with ~)
    static let appID = "ca-app-pub-5223337070047795~9361812948"
    
    // Ad Unit IDs (ends with /) - Replace with your actual Ad Unit IDs from AdMob console
    // You need to create a Banner Ad Unit in AdMob console to get this ID
    static let bannerAdUnitID = "ca-app-pub-5223337070047795/5230996241" // Using test ID until you create real ad unit
    // Your App ID: ca-app-pub-5223337070047795~9361812948 (This is NOT an Ad Unit ID)
    
    // Optional: Different ad units for different placements
    static let homeTabBannerID = "xxxxxxxx" // Optional: specific for home tab
    static let favoritesTabBannerID = "xxxxxxxx" // Optional: specific for favorites tab
    static let learnTabBannerID = "xxxxxxxx" // Optional: specific for learn tab
    
    // Test Ad Unit IDs (Google's official test IDs)
    static let testBannerAdUnitID = "ca-app-pub-5223337070047795/5230996241" // iOS Banner test ID
    
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
