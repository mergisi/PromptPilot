//
//  PremiumManager.swift
//  PromptPilot
//
//  Created by mustafa ergisi on 8/4/25.
//

import Foundation
import StoreKit

class PremiumManager: NSObject, ObservableObject {
    static let shared = PremiumManager()
    
    @Published var isPremium: Bool = false
    @Published var isLoading: Bool = false
    
    // Product IDs - App Store Connect'te tanımlanacak
    private let premiumMonthlyProductID = "com.promptpilot.premium.monthly"
    private let premiumYearlyProductID = "com.promptpilot.premium.yearly"
    
    // Limits
    static let freeCollectionLimit = 2
    static let freeCollectionPromptLimit = 10
    static let freeFavoriteLimit = 10
    static let freeImportLimit = 5
    
    private var products: [SKProduct] = []
    
    override init() {
        super.init()
        SKPaymentQueue.default().add(self)
        loadPremiumStatus()
        requestProducts()
    }
    
    deinit {
        SKPaymentQueue.default().remove(self)
    }
    
    // MARK: - Premium Status
    private func loadPremiumStatus() {
        isPremium = UserDefaults.standard.bool(forKey: "isPremium")
    }
    
    private func savePremiumStatus() {
        UserDefaults.standard.set(isPremium, forKey: "isPremium")
    }
    
    // MARK: - Product Requests
    private func requestProducts() {
        let productIDs = Set([premiumMonthlyProductID, premiumYearlyProductID])
        let request = SKProductsRequest(productIdentifiers: productIDs)
        request.delegate = self
        request.start()
    }
    
    // MARK: - Purchase Methods
    func purchaseMonthly() {
        guard let product = products.first(where: { $0.productIdentifier == premiumMonthlyProductID }) else {
            print("Monthly product not found")
            return
        }
        
        // Track purchase attempt
        let price = getMonthlyPrice()
        MixpanelManager.shared.trackPurchaseAttempted(
            productId: premiumMonthlyProductID,
            productType: "monthly",
            price: price
        )
        
        purchase(product: product)
    }
    
    func purchaseYearly() {
        guard let product = products.first(where: { $0.productIdentifier == premiumYearlyProductID }) else {
            print("Yearly product not found")
            return
        }
        
        // Track purchase attempt
        let price = getYearlyPrice()
        MixpanelManager.shared.trackPurchaseAttempted(
            productId: premiumYearlyProductID,
            productType: "yearly",
            price: price
        )
        
        purchase(product: product)
    }
    
    private func purchase(product: SKProduct) {
        guard SKPaymentQueue.canMakePayments() else {
            print("Payments not allowed")
            return
        }
        
        isLoading = true
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    func restorePurchases() {
        isLoading = true
        MixpanelManager.shared.trackRestorePurchasesAttempted()
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    // MARK: - Limit Checks
    func canCreateCollection(currentCount: Int) -> Bool {
        return isPremium || currentCount < Self.freeCollectionLimit
    }
    
    func canAddToCollection(currentCount: Int) -> Bool {
        return isPremium || currentCount < Self.freeCollectionPromptLimit
    }
    
    func canAddFavorite(currentCount: Int) -> Bool {
        return isPremium || currentCount < Self.freeFavoriteLimit
    }
    
    func canImportPrompt(currentCount: Int) -> Bool {
        return isPremium || currentCount < Self.freeImportLimit
    }
    
    // MARK: - Product Info
    func getMonthlyPrice() -> String {
        guard let product = products.first(where: { $0.productIdentifier == premiumMonthlyProductID }) else {
            return "$2.99"
        }
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = product.priceLocale
        return formatter.string(from: product.price) ?? "$2.99"
    }
    
    func getYearlyPrice() -> String {
        guard let product = products.first(where: { $0.productIdentifier == premiumYearlyProductID }) else {
            return "$19.99"
        }
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = product.priceLocale
        return formatter.string(from: product.price) ?? "$19.99"
    }
}

// MARK: - SKProductsRequestDelegate
extension PremiumManager: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        DispatchQueue.main.async {
            self.products = response.products
            print("Products loaded: \(response.products.count)")
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print("Product request failed: \(error.localizedDescription)")
    }
}

// MARK: - SKPaymentTransactionObserver
extension PremiumManager: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                handlePurchased(transaction)
            case .restored:
                handleRestored(transaction)
            case .failed:
                handleFailed(transaction)
            case .deferred:
                handleDeferred()
            case .purchasing:
                break
            @unknown default:
                break
            }
        }
    }
    
    private func handlePurchased(_ transaction: SKPaymentTransaction) {
        // Track successful purchase
        let productId = transaction.payment.productIdentifier
        let productType = productId.contains("monthly") ? "monthly" : "yearly"
        let price = productId.contains("monthly") ? getMonthlyPrice() : getYearlyPrice()
        
        MixpanelManager.shared.trackPurchaseCompleted(
            productId: productId,
            productType: productType,
            price: price
        )
        
        DispatchQueue.main.async {
            self.isPremium = true
            self.savePremiumStatus()
            self.isLoading = false
        }
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func handleRestored(_ transaction: SKPaymentTransaction) {
        // Track successful restore
        MixpanelManager.shared.trackRestorePurchasesCompleted(success: true)
        
        DispatchQueue.main.async {
            self.isPremium = true
            self.savePremiumStatus()
            self.isLoading = false
        }
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func handleFailed(_ transaction: SKPaymentTransaction) {
        // Track failed purchase
        let productId = transaction.payment.productIdentifier
        let productType = productId.contains("monthly") ? "monthly" : "yearly"
        let errorCode = (transaction.error as? SKError)?.code.rawValue.description ?? "unknown"
        let errorDescription = transaction.error?.localizedDescription ?? "Unknown error"
        
        MixpanelManager.shared.trackPurchaseFailed(
            productId: productId,
            productType: productType,
            errorCode: errorCode,
            errorDescription: errorDescription
        )
        
        DispatchQueue.main.async {
            self.isLoading = false
        }
        if let error = transaction.error as? SKError {
            print("Transaction failed: \(error.localizedDescription)")
        }
        SKPaymentQueue.default().finishTransaction(transaction)
    }
    
    private func handleDeferred() {
        DispatchQueue.main.async {
            self.isLoading = false
        }
    }
}
