//
//  PremiumView.swift
//  PromptPilot
//
//  Created by mustafa ergisi on 8/4/25.
//

import SwiftUI

struct PremiumView: View {
    @StateObject private var premiumManager = PremiumManager.shared
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 16) {
                        Image(systemName: "crown.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.yellow)
                        
                        Text("PromptPilot Premium")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.pilotBlue)
                        
                        Text("Unlock unlimited prompts and advanced features")
                            .font(.headline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top, 20)
                    
                    // Features
                    VStack(spacing: 16) {
                        PremiumFeatureRow(
                            icon: "infinity",
                            title: "Unlimited Collections",
                            description: "Create as many collections as you want",
                            isHighlighted: true
                        )
                        
                        PremiumFeatureRow(
                            icon: "heart.fill",
                            title: "Unlimited Favorites",
                            description: "Save all your favorite prompts",
                            isHighlighted: true
                        )
                        
                        PremiumFeatureRow(
                            icon: "sparkles",
                            title: "Premium Prompts",
                            description: "Access to exclusive prompt library",
                            isHighlighted: false
                        )
                        
                        PremiumFeatureRow(
                            icon: "wand.and.rays",
                            title: "Advanced Features",
                            description: "Priority support and early access",
                            isHighlighted: false
                        )
                    }
                    .padding(.horizontal)
                    
                    // Current Limits (if not premium)
                    if !premiumManager.isPremium {
                        VStack(spacing: 12) {
                            Text("Free Plan Limits")
                                .font(.headline)
                                .foregroundColor(.secondary)
                            
                            HStack {
                                VStack {
                                    Text("\(PremiumManager.freeCollectionLimit)")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.pilotBlue)
                                    Text("Collections")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                VStack {
                                    Text("\(PremiumManager.freeFavoriteLimit)")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.pilotBlue)
                                    Text("Favorites")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                                
                                VStack {
                                    Text("\(PremiumManager.freeCollectionPromptLimit)")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(.pilotBlue)
                                    Text("Per Collection")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding()
                            .background(Color.lightBlue.opacity(0.1))
                            .cornerRadius(12)
                        }
                        .padding(.horizontal)
                    }
                    
                    // Pricing
                    if !premiumManager.isPremium {
                        VStack(spacing: 16) {
                            Text("Choose Your Plan")
                                .font(.headline)
                                .foregroundColor(.pilotBlue)
                            
                            // Yearly Plan (Recommended)
                            Button(action: {
                                premiumManager.purchaseYearly()
                            }) {
                                VStack(spacing: 8) {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            HStack {
                                                Text("Yearly")
                                                    .font(.headline)
                                                    .fontWeight(.bold)
                                                
                                                                                Text("SAVE 85%")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 2)
                                    .background(Color.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(4)
                                            }
                                            
                                                                        Text("Start 7-Day Free Trial")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.pilotBlue)
                            
                            Text("Then \(premiumManager.getYearlyPrice())/year")
                                .font(.subheadline)
                                .foregroundColor(.primary)
                            
                            Text("Cancel anytime")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                        }
                                        
                                        Spacer()
                                        
                                        Image(systemName: "checkmark.circle.fill")
                                            .font(.title2)
                                            .foregroundColor(.pilotBlue)
                                    }
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.pilotBlue.opacity(0.1))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.pilotBlue, lineWidth: 2)
                                )
                                .cornerRadius(12)
                            }
                            .foregroundColor(.primary)
                            .disabled(premiumManager.isLoading)
                            
                            // Monthly Plan
                            Button(action: {
                                premiumManager.purchaseMonthly()
                            }) {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("Monthly")
                                            .font(.headline)
                                            .fontWeight(.bold)
                                        
                                        Text("Start 7-Day Free Trial")
                                            .font(.title3)
                                            .fontWeight(.bold)
                                            .foregroundColor(.pilotBlue)
                                        
                                        Text("Then \(premiumManager.getMonthlyPrice())/month")
                                            .font(.subheadline)
                                            .foregroundColor(.primary)
                                        
                                        Text("Cancel anytime")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Spacer()
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(12)
                            }
                            .foregroundColor(.primary)
                            .disabled(premiumManager.isLoading)
                        }
                        .padding(.horizontal)
                        
                        // Restore Purchases
                        Button("Restore Purchases") {
                            premiumManager.restorePurchases()
                        }
                        .foregroundColor(.pilotBlue)
                        .disabled(premiumManager.isLoading)
                    } else {
                        // Already Premium
                        VStack(spacing: 16) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.green)
                            
                            Text("You're Premium!")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.pilotBlue)
                            
                            Text("Enjoy unlimited access to all features")
                                .foregroundColor(.secondary)
                        }
                        .padding()
                    }
                    
                    // Loading State
                    if premiumManager.isLoading {
                        ProgressView("Processing...")
                            .padding()
                    }
                    
                    // Legal Links
                    VStack(spacing: 8) {
                        HStack {
                            Button("Terms of Use") {
                                if let url = URL(string: "https://mergisi.github.io/PromptPilot/terms-of-use.html") {
                                    UIApplication.shared.open(url)
                                }
                            }
                            .foregroundColor(.pilotBlue)
                            
                            Text("•")
                                .foregroundColor(.secondary)
                            
                            Button("Privacy Policy") {
                                if let url = URL(string: "https://mergisi.github.io/PromptPilot/privacy-policy.html") {
                                    UIApplication.shared.open(url)
                                }
                            }
                            .foregroundColor(.pilotBlue)
                        }
                        .font(.caption)
                        
                        Text("Subscriptions auto-renew unless cancelled 24h before period ends")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal)
                    
                    Spacer(minLength: 20)
                }
            }
            .navigationTitle("Premium")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
}

struct PremiumFeatureRow: View {
    let icon: String
    let title: String
    let description: String
    let isHighlighted: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(isHighlighted ? .pilotBlue : .secondary)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            if isHighlighted {
                Image(systemName: "star.fill")
                    .font(.caption)
                    .foregroundColor(.yellow)
            }
        }
        .padding()
        .background(isHighlighted ? Color.lightBlue.opacity(0.1) : Color.clear)
        .cornerRadius(12)
    }
}

#Preview {
    PremiumView()
}
