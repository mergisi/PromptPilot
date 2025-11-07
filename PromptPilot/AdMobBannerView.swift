//
//  AdMobBannerView.swift
//  PromptPilot
//
//  Created by AI Assistant on 9/15/25.
//

import SwiftUI
import GoogleMobileAds
import UIKit

// Use the centralized configuration
typealias AdMobConfig = AdMobConfiguration

// MARK: - SwiftUI AdMob Banner View
struct AdMobBannerView: UIViewRepresentable {
    let adUnitID: String
    let adSize: AdSize
    
    init(adUnitID: String = AdMobConfig.primaryBannerAdUnitID, adSize: AdSize = AdSizeBanner) {
        self.adUnitID = adUnitID
        self.adSize = adSize
    }
    
    func makeUIView(context: Context) -> BannerView {
        // Create the banner view with the specified ad size
        let bannerView = BannerView(adSize: adSize)
        bannerView.adUnitID = adUnitID
        
        // Get the root view controller (SwiftUI compatible way)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            bannerView.rootViewController = rootViewController
        }
        
        bannerView.delegate = context.coordinator
        
        // Load the ad
        bannerView.load(Request())
        
        return bannerView
    }
    
    func updateUIView(_ uiView: BannerView, context: Context) {
        // Update if needed - could refresh ad here if needed
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // MARK: - Coordinator
    class Coordinator: NSObject, BannerViewDelegate {
        let parent: AdMobBannerView
        
        init(_ parent: AdMobBannerView) {
            self.parent = parent
        }
        
        // MARK: - BannerViewDelegate
        func bannerViewDidReceiveAd(_ bannerView: BannerView) {
            print("✅ AdMob Banner: Ad loaded successfully")
        }
        
        func bannerView(_ bannerView: BannerView, didFailToReceiveAdWithError error: Error) {
            print("❌ AdMob Banner: Failed to load ad - \(error.localizedDescription)")
        }
        
        func bannerViewDidRecordImpression(_ bannerView: BannerView) {
            print("📊 AdMob Banner: Ad impression recorded")
        }
        
        func bannerViewWillPresentScreen(_ bannerView: BannerView) {
            print("📱 AdMob Banner: Will present screen")
        }
        
        func bannerViewWillDismissScreen(_ bannerView: BannerView) {
            print("📱 AdMob Banner: Will dismiss screen")
        }
        
        func bannerViewDidDismissScreen(_ bannerView: BannerView) {
            print("📱 AdMob Banner: Did dismiss screen")
        }
    }
}

// MARK: - Banner Container View
struct BannerAdContainer: View {
    @EnvironmentObject var premiumManager: PremiumManager
    let showForPremium: Bool
    
    init(showForPremium: Bool = false) {
        self.showForPremium = showForPremium
    }
    
    var body: some View {
        // Only show ads for non-premium users (unless specifically requested)
        if !premiumManager.isPremium || showForPremium {
            VStack(spacing: 0) {
                // Separator line
                Divider()
                    .background(Color.gray.opacity(0.3))
                
                // Ad banner
                AdMobBannerView()
                    .frame(height: 50) // Standard banner height
                    .background(Color.gray.opacity(0.1))
            }
        }
    }
}

// MARK: - Smart Banner (Adaptive)
struct AdMobSmartBannerView: UIViewRepresentable {
    let adUnitID: String
    
    init(adUnitID: String = AdMobConfig.primaryBannerAdUnitID) {
        self.adUnitID = adUnitID
    }
    
    func makeUIView(context: Context) -> BannerView {
        let bannerView = BannerView(adSize: currentOrientationAnchoredAdaptiveBanner(width: UIScreen.main.bounds.width))
        bannerView.adUnitID = adUnitID
        
        // Get the root view controller (SwiftUI compatible way)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            bannerView.rootViewController = rootViewController
        }
        
        bannerView.delegate = context.coordinator
        
        // Load the ad
        let request = Request()
        bannerView.load(request)
        
        return bannerView
    }
    
    func updateUIView(_ uiView: BannerView, context: Context) {
        // Update if needed
    }
    
    func makeCoordinator() -> AdMobBannerView.Coordinator {
        AdMobBannerView.Coordinator(AdMobBannerView())
    }
}

// MARK: - Preview
struct AdMobBannerView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Text("Content Above")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.blue.opacity(0.1))
            
            BannerAdContainer()
        }
        .environmentObject(PremiumManager.shared)
    }
}
