//
//  MixpanelManager.swift
//  PromptPilot
//
//  Created by AI Assistant on 9/15/25.
//

import Foundation
import Mixpanel

class MixpanelManager: ObservableObject {
    static let shared = MixpanelManager()
    
    private let mixpanel: MixpanelInstance
    
    // MARK: - Event Names
    struct Events {
        // App Lifecycle
        static let appLaunched = "App Launched"
        static let appForegrounded = "App Foregrounded"
        
        // Premium Flow
        static let premiumViewShown = "Premium View Shown"
        static let purchaseAttempted = "Purchase Attempted"
        static let purchaseCompleted = "Purchase Completed"
        static let purchaseFailed = "Purchase Failed"
        static let restorePurchasesAttempted = "Restore Purchases Attempted"
        static let restorePurchasesCompleted = "Restore Purchases Completed"
        
        // Limit Reached Events
        static let collectionLimitReached = "Collection Limit Reached"
        static let favoriteLimitReached = "Favorite Limit Reached"
        static let importLimitReached = "Import Limit Reached"
        static let collectionPromptLimitReached = "Collection Prompt Limit Reached"
        
        // User Actions
        static let promptViewed = "Prompt Viewed"
        static let promptCopied = "Prompt Copied"
        static let promptSharedToAI = "Prompt Shared to AI"
        static let promptImported = "Prompt Imported"
        static let collectionCreated = "Collection Created"
        static let favoriteToggled = "Favorite Toggled"
        static let templateUsed = "Template Used"
        
        // Navigation
        static let tabSwitched = "Tab Switched"
        static let filterApplied = "Filter Applied"
        static let searchPerformed = "Search Performed"
    }
    
    // MARK: - Properties
    struct Properties {
        // User
        static let isPremium = "Is Premium"
        static let userType = "User Type"
        
        // Purchase
        static let productId = "Product ID"
        static let productType = "Product Type"
        static let price = "Price"
        static let currency = "Currency"
        static let errorCode = "Error Code"
        static let errorDescription = "Error Description"
        
        // Limits
        static let currentCount = "Current Count"
        static let limitValue = "Limit Value"
        static let limitType = "Limit Type"
        
        // Content
        static let promptId = "Prompt ID"
        static let promptCategory = "Prompt Category"
        static let promptTitle = "Prompt Title"
        static let aiModel = "AI Model"
        static let collectionId = "Collection ID"
        static let collectionName = "Collection Name"
        static let templateId = "Template ID"
        static let templateCategory = "Template Category"
        
        // Navigation
        static let fromTab = "From Tab"
        static let toTab = "To Tab"
        static let filterType = "Filter Type"
        static let filterValue = "Filter Value"
        static let searchQuery = "Search Query"
        static let searchResultsCount = "Search Results Count"
    }
    
    private init() {
        // Initialize with your Mixpanel token from config
        let token = MixpanelConfig.token
        
        #if DEBUG
        // Use a different token for debug builds if needed
        mixpanel = Mixpanel.initialize(token: token, trackAutomaticEvents: true)
        mixpanel.loggingEnabled = true
        #else
        mixpanel = Mixpanel.initialize(token: token, trackAutomaticEvents: true)
        #endif
        
        setupUserProperties()
    }
    
    // MARK: - Setup
    private func setupUserProperties() {
        // Set initial user properties
        let isPremium = UserDefaults.standard.bool(forKey: "isPremium")
        mixpanel.people.set(properties: [
            Properties.isPremium: isPremium,
            Properties.userType: isPremium ? "Premium" : "Free"
        ])
    }
    
    // MARK: - User Management
    func identifyUser(_ userId: String) {
        mixpanel.identify(distinctId: userId)
    }
    
    func updateUserProperties(isPremium: Bool) {
        mixpanel.people.set(properties: [
            Properties.isPremium: isPremium,
            Properties.userType: isPremium ? "Premium" : "Free"
        ])
    }
    
    // MARK: - App Lifecycle Events
    func trackAppLaunched() {
        let isPremium = UserDefaults.standard.bool(forKey: "isPremium")
        track(Events.appLaunched, properties: [
            Properties.isPremium: isPremium,
            Properties.userType: isPremium ? "Premium" : "Free"
        ])
    }
    
    func trackAppForegrounded() {
        let isPremium = UserDefaults.standard.bool(forKey: "isPremium")
        track(Events.appForegrounded, properties: [
            Properties.isPremium: isPremium
        ])
    }
    
    // MARK: - Premium Flow Events
    func trackPremiumViewShown(source: String = "unknown") {
        track(Events.premiumViewShown, properties: [
            "source": source,
            Properties.isPremium: UserDefaults.standard.bool(forKey: "isPremium")
        ])
    }
    
    func trackPurchaseAttempted(productId: String, productType: String, price: String) {
        track(Events.purchaseAttempted, properties: [
            Properties.productId: productId,
            Properties.productType: productType,
            Properties.price: price
        ])
    }
    
    func trackPurchaseCompleted(productId: String, productType: String, price: String) {
        track(Events.purchaseCompleted, properties: [
            Properties.productId: productId,
            Properties.productType: productType,
            Properties.price: price
        ])
        
        // Update user properties
        updateUserProperties(isPremium: true)
    }
    
    func trackPurchaseFailed(productId: String, productType: String, errorCode: String, errorDescription: String) {
        track(Events.purchaseFailed, properties: [
            Properties.productId: productId,
            Properties.productType: productType,
            Properties.errorCode: errorCode,
            Properties.errorDescription: errorDescription
        ])
    }
    
    func trackRestorePurchasesAttempted() {
        track(Events.restorePurchasesAttempted)
    }
    
    func trackRestorePurchasesCompleted(success: Bool) {
        track(Events.restorePurchasesCompleted, properties: [
            "success": success
        ])
        
        if success {
            updateUserProperties(isPremium: true)
        }
    }
    
    // MARK: - Limit Reached Events
    func trackCollectionLimitReached(currentCount: Int) {
        track(Events.collectionLimitReached, properties: [
            Properties.currentCount: currentCount,
            Properties.limitValue: PremiumManager.freeCollectionLimit,
            Properties.limitType: "collections"
        ])
    }
    
    func trackFavoriteLimitReached(currentCount: Int) {
        track(Events.favoriteLimitReached, properties: [
            Properties.currentCount: currentCount,
            Properties.limitValue: PremiumManager.freeFavoriteLimit,
            Properties.limitType: "favorites"
        ])
    }
    
    func trackImportLimitReached(currentCount: Int) {
        track(Events.importLimitReached, properties: [
            Properties.currentCount: currentCount,
            Properties.limitValue: PremiumManager.freeImportLimit,
            Properties.limitType: "imports"
        ])
    }
    
    func trackCollectionPromptLimitReached(currentCount: Int, collectionId: String, collectionName: String) {
        track(Events.collectionPromptLimitReached, properties: [
            Properties.currentCount: currentCount,
            Properties.limitValue: PremiumManager.freeCollectionPromptLimit,
            Properties.limitType: "collection_prompts",
            Properties.collectionId: collectionId,
            Properties.collectionName: collectionName
        ])
    }
    
    // MARK: - User Action Events
    func trackPromptViewed(promptId: String, promptTitle: String, category: String, source: String = "list") {
        track(Events.promptViewed, properties: [
            Properties.promptId: promptId,
            Properties.promptTitle: promptTitle,
            Properties.promptCategory: category,
            "source": source,
            Properties.isPremium: UserDefaults.standard.bool(forKey: "isPremium")
        ])
    }
    
    func trackPromptCopied(promptId: String, promptTitle: String, category: String) {
        track(Events.promptCopied, properties: [
            Properties.promptId: promptId,
            Properties.promptTitle: promptTitle,
            Properties.promptCategory: category,
            Properties.isPremium: UserDefaults.standard.bool(forKey: "isPremium")
        ])
    }
    
    func trackPromptSharedToAI(promptId: String, promptTitle: String, category: String, aiModel: String) {
        track(Events.promptSharedToAI, properties: [
            Properties.promptId: promptId,
            Properties.promptTitle: promptTitle,
            Properties.promptCategory: category,
            Properties.aiModel: aiModel,
            Properties.isPremium: UserDefaults.standard.bool(forKey: "isPremium")
        ])
    }
    
    func trackPromptImported(promptId: String, promptTitle: String, category: String, method: String = "manual") {
        track(Events.promptImported, properties: [
            Properties.promptId: promptId,
            Properties.promptTitle: promptTitle,
            Properties.promptCategory: category,
            "import_method": method,
            Properties.isPremium: UserDefaults.standard.bool(forKey: "isPremium")
        ])
    }
    
    func trackCollectionCreated(collectionId: String, collectionName: String) {
        track(Events.collectionCreated, properties: [
            Properties.collectionId: collectionId,
            Properties.collectionName: collectionName,
            Properties.isPremium: UserDefaults.standard.bool(forKey: "isPremium")
        ])
    }
    
    func trackFavoriteToggled(promptId: String, promptTitle: String, category: String, isAdding: Bool) {
        track(Events.favoriteToggled, properties: [
            Properties.promptId: promptId,
            Properties.promptTitle: promptTitle,
            Properties.promptCategory: category,
            "action": isAdding ? "add" : "remove",
            Properties.isPremium: UserDefaults.standard.bool(forKey: "isPremium")
        ])
    }
    
    func trackTemplateUsed(templateId: String, templateCategory: String, templateTitle: String) {
        track(Events.templateUsed, properties: [
            Properties.templateId: templateId,
            Properties.templateCategory: templateCategory,
            "template_title": templateTitle,
            Properties.isPremium: UserDefaults.standard.bool(forKey: "isPremium")
        ])
    }
    
    // MARK: - Navigation Events
    func trackTabSwitched(fromTab: String, toTab: String) {
        track(Events.tabSwitched, properties: [
            Properties.fromTab: fromTab,
            Properties.toTab: toTab
        ])
    }
    
    func trackFilterApplied(filterType: String, filterValue: String) {
        track(Events.filterApplied, properties: [
            Properties.filterType: filterType,
            Properties.filterValue: filterValue
        ])
    }
    
    func trackSearchPerformed(query: String, resultsCount: Int) {
        track(Events.searchPerformed, properties: [
            Properties.searchQuery: query,
            Properties.searchResultsCount: resultsCount
        ])
    }
    
    // MARK: - Helper Methods
    private func track(_ event: String, properties: [String: MixpanelType] = [:]) {
        var finalProperties = properties
        
        // Add common properties to every event
        finalProperties["platform"] = "iOS"
        finalProperties["app_version"] = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "unknown"
        finalProperties["build_number"] = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "unknown"
        
        mixpanel.track(event: event, properties: finalProperties)
        
        #if DEBUG
        print("🔍 Mixpanel Event: \(event)")
        print("📊 Properties: \(finalProperties)")
        #endif
    }
    
    // MARK: - Flush
    func flush() {
        mixpanel.flush()
    }
}

// MARK: - Convenience Extensions
extension MixpanelManager {
    
    // Track premium upgrade flow step by step
    func trackPremiumUpgradeFlow(step: String, source: String, additionalProperties: [String: MixpanelType] = [:]) {
        var properties: [String: MixpanelType] = [
            "step": step,
            "source": source,
            Properties.isPremium: UserDefaults.standard.bool(forKey: "isPremium")
        ]
        
        // Merge additional properties
        for (key, value) in additionalProperties {
            properties[key] = value
        }
        
        track("Premium Upgrade Flow", properties: properties)
    }
    
    // Track user engagement metrics
    func trackEngagementMetric(metric: String, value: Double, context: [String: MixpanelType] = [:]) {
        var properties = context
        properties["metric"] = metric
        properties["value"] = value
        properties[Properties.isPremium] = UserDefaults.standard.bool(forKey: "isPremium")
        
        track("Engagement Metric", properties: properties)
    }
}
