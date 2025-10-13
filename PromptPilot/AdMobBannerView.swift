//
//  AdMobBannerView.swift
//  PromptPilot
//
//  Created by AI Assistant on 9/15/25.
//

import SwiftUI
// import GoogleMobileAds // TODO: Add back when GoogleMobileAds package is resolved
import UIKit

// Use the centralized configuration
typealias AdMobConfig = AdMobConfiguration

// MARK: - SwiftUI AdMob Banner View (Placeholder until GoogleMobileAds is added)
struct AdMobBannerView: UIViewRepresentable {
    let adUnitID: String
    // let adSize: GADAdSize // TODO: Uncomment when GoogleMobileAds is added
    
    init(adUnitID: String = AdMobConfig.primaryBannerAdUnitID) { // , adSize: GADAdSize = GADAdSizeBanner
        self.adUnitID = adUnitID
        // self.adSize = adSize
    }
    
    func makeUIView(context: Context) -> UIView { // GADBannerView
        // TODO: Replace with GADBannerView when GoogleMobileAds is added
        let placeholderView = UIView()
        placeholderView.backgroundColor = UIColor.systemGray6
        
        let label = UILabel()
        label.text = "Ad Placeholder"
        label.textAlignment = .center
        label.textColor = UIColor.systemGray
        label.translatesAutoresizingMaskIntoConstraints = false
        
        placeholderView.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: placeholderView.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: placeholderView.centerYAnchor)
        ])
        
        return placeholderView
        
        /*
        // TODO: Uncomment when GoogleMobileAds is added - Based on your UIKit implementation
        let bannerView = GADBannerView(adSize: GADAdSizeBanner)
        bannerView.adUnitID = adUnitID // Using your format: "ca-app-pub-1234567890123456/1122334455"
        
        // Get the root view controller (SwiftUI compatible way)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            bannerView.rootViewController = rootViewController
        }
        
        bannerView.delegate = context.coordinator
        
        // Load the ad (following your pattern)
        bannerView.load(GADRequest())
        
        return bannerView
        */
    }
    
    func updateUIView(_ uiView: UIView, context: Context) { // GADBannerView
        // Update if needed
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // MARK: - Coordinator (Placeholder until GoogleMobileAds is added)
    class Coordinator: NSObject { // , GADBannerViewDelegate
        let parent: AdMobBannerView
        
        init(_ parent: AdMobBannerView) {
            self.parent = parent
        }
        
        /*
        // TODO: Uncomment when GoogleMobileAds is added
        // MARK: - GADBannerViewDelegate
        func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
            print("✅ AdMob Banner: Ad loaded successfully")
        }
        
        func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
            print("❌ AdMob Banner: Failed to load ad - \(error.localizedDescription)")
        }
        
        func bannerViewDidRecordImpression(_ bannerView: GADBannerView) {
            print("📊 AdMob Banner: Ad impression recorded")
        }
        
        func bannerViewWillPresentScreen(_ bannerView: GADBannerView) {
            print("📱 AdMob Banner: Will present screen")
        }
        
        func bannerViewWillDismissScreen(_ bannerView: GADBannerView) {
            print("📱 AdMob Banner: Will dismiss screen")
        }
        
        func bannerViewDidDismissScreen(_ bannerView: GADBannerView) {
            print("📱 AdMob Banner: Did dismiss screen")
        }
        */
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

/*
// MARK: - Smart Banner (Adaptive) - TODO: Uncomment when GoogleMobileAds is added
struct AdMobSmartBannerView: UIViewRepresentable {
    let adUnitID: String
    
    init(adUnitID: String = AdMobConfig.primaryBannerAdUnitID) {
        self.adUnitID = adUnitID
    }
    
    func makeUIView(context: Context) -> GADBannerView {
        let bannerView = GADBannerView(adSize: GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(UIScreen.main.bounds.width))
        bannerView.adUnitID = adUnitID
        bannerView.rootViewController = UIApplication.shared.windows.first?.rootViewController
        bannerView.delegate = context.coordinator
        
        // Load the ad
        let request = GADRequest()
        bannerView.load(request)
        
        return bannerView
    }
    
    func updateUIView(_ uiView: GADBannerView, context: Context) {
        // Update if needed
    }
    
    func makeCoordinator() -> AdMobBannerView.Coordinator {
        AdMobBannerView.Coordinator(AdMobBannerView())
    }
}
*/

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
