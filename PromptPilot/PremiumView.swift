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
    @State private var selectedPlan: PlanType = .yearly
    
    enum PlanType {
        case monthly, yearly
    }
    
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
                    
                    // Pricing (EN ÜST - En önemli kısım)
                    if !premiumManager.isPremium {
                        VStack(spacing: 20) {
                            VStack(spacing: 8) {
                                Text("Choose Your Plan")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.pilotBlue)
                                
                                Text("Select a plan to start your free trial")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            
                            // Plan Selection
                            VStack(spacing: 12) {
                                // Yearly Plan (Recommended)
                                Button(action: {
                                    selectedPlan = .yearly
                                }) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 8) {
                                            HStack {
                                                Text("Yearly")
                                                    .font(.headline)
                                                    .fontWeight(.bold)
                                                    .foregroundColor(selectedPlan == .yearly ? .white : .primary)
                                                
                                                Text("SAVE 85%")
                                                    .font(.caption)
                                                    .fontWeight(.bold)
                                                    .padding(.horizontal, 8)
                                                    .padding(.vertical, 2)
                                                    .background(Color.green)
                                                    .foregroundColor(.white)
                                                    .cornerRadius(4)
                                            }
                                            
                                            Text("7-Day Free Trial")
                                                .font(.subheadline)
                                                .fontWeight(.medium)
                                                .foregroundColor(selectedPlan == .yearly ? .white.opacity(0.9) : .pilotBlue)
                                            
                                            Text("Then \(premiumManager.getYearlyPrice())/year")
                                                .font(.subheadline)
                                                .foregroundColor(selectedPlan == .yearly ? .white.opacity(0.8) : .secondary)
                                        }
                                        
                                        Spacer()
                                        
                                        // Selection indicator
                                        ZStack {
                                            Circle()
                                                .stroke(selectedPlan == .yearly ? .white : Color.gray, lineWidth: 2)
                                                .frame(width: 24, height: 24)
                                            
                                            if selectedPlan == .yearly {
                                                Circle()
                                                    .fill(.white)
                                                    .frame(width: 12, height: 12)
                                            }
                                        }
                                    }
                                    .padding()
                                    .background(selectedPlan == .yearly ? Color.pilotBlue : Color.gray.opacity(0.05))
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(selectedPlan == .yearly ? Color.pilotBlue : Color.gray.opacity(0.3), lineWidth: selectedPlan == .yearly ? 2 : 1)
                                    )
                                    .scaleEffect(selectedPlan == .yearly ? 1.02 : 1.0)
                                    .animation(.easeInOut(duration: 0.2), value: selectedPlan)
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                // Monthly Plan
                                Button(action: {
                                    selectedPlan = .monthly
                                }) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 8) {
                                            Text("Monthly")
                                                .font(.headline)
                                                .fontWeight(.bold)
                                                .foregroundColor(selectedPlan == .monthly ? .white : .primary)
                                            
                                            Text("7-Day Free Trial")
                                                .font(.subheadline)
                                                .fontWeight(.medium)
                                                .foregroundColor(selectedPlan == .monthly ? .white.opacity(0.9) : .pilotBlue)
                                            
                                            Text("Then \(premiumManager.getMonthlyPrice())/month")
                                                .font(.subheadline)
                                                .foregroundColor(selectedPlan == .monthly ? .white.opacity(0.8) : .secondary)
                                        }
                                        
                                        Spacer()
                                        
                                        // Selection indicator
                                        ZStack {
                                            Circle()
                                                .stroke(selectedPlan == .monthly ? .white : Color.gray, lineWidth: 2)
                                                .frame(width: 24, height: 24)
                                            
                                            if selectedPlan == .monthly {
                                                Circle()
                                                    .fill(.white)
                                                    .frame(width: 12, height: 12)
                                            }
                                        }
                                    }
                                    .padding()
                                    .background(selectedPlan == .monthly ? Color.pilotBlue : Color.gray.opacity(0.05))
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(selectedPlan == .monthly ? Color.pilotBlue : Color.gray.opacity(0.3), lineWidth: selectedPlan == .monthly ? 2 : 1)
                                    )
                                    .scaleEffect(selectedPlan == .monthly ? 1.02 : 1.0)
                                    .animation(.easeInOut(duration: 0.2), value: selectedPlan)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            
                            // Start Trial Button
                            Button(action: {
                                if selectedPlan == .yearly {
                                    premiumManager.purchaseYearly()
                                } else {
                                    premiumManager.purchaseMonthly()
                                }
                            }) {
                                HStack {
                                    if premiumManager.isLoading {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                            .scaleEffect(0.8)
                                    }
                                    
                                    Text(premiumManager.isLoading ? "Starting Trial..." : "Start Free Trial")
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.green, Color.green.opacity(0.8)]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .foregroundColor(.white)
                                .cornerRadius(12)
                                .shadow(color: Color.green.opacity(0.3), radius: 8, x: 0, y: 4)
                            }
                            .disabled(premiumManager.isLoading)
                            
                            Text("Cancel anytime • No commitment")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                            
                            // Legal Links
                            HStack(spacing: 20) {
                                Link("Terms of Use", destination: URL(string: "https://mergisi.github.io/PromptPilot/terms-of-use.html")!)
                                    .font(.caption)
                                    .foregroundColor(.pilotBlue)
                                
                                Link("Privacy Policy", destination: URL(string: "https://mergisi.github.io/PromptPilot/privacy-policy.html")!)
                                    .font(.caption)
                                    .foregroundColor(.pilotBlue)
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    // Features (Pricing'den sonra)
                    VStack(spacing: 16) {
                        Text("What You Get")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.pilotBlue)
                            .padding(.top, 8)
                        
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
                            icon: "plus.circle.fill",
                            title: "Unlimited Imports",
                            description: "Import prompts from anywhere without limits",
                            isHighlighted: true
                        )
                        
                        PremiumFeatureRow(
                            icon: "wand.and.stars",
                            title: "Custom Templates",
                            description: "Create and customize prompt templates",
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
                            
                            VStack(spacing: 12) {
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
                                
                                // Second row for imports
                                HStack {
                                    VStack {
                                        Text("\(PremiumManager.freeImportLimit)")
                                            .font(.title2)
                                            .fontWeight(.bold)
                                            .foregroundColor(.pilotBlue)
                                        Text("Imports")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    
                                    Spacer()
                                    
                                    VStack {
                                        Text("∞")
                                            .font(.title2)
                                            .fontWeight(.bold)
                                            .foregroundColor(.gray)
                                        Text("Templates")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                    
                                    Spacer()
                                    
                                    VStack {
                                        Text("∞")
                                            .font(.title2)
                                            .fontWeight(.bold)
                                            .foregroundColor(.gray)
                                        Text("Premium")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                            .padding()
                            .background(Color.lightBlue.opacity(0.1))
                            .cornerRadius(12)
                        }
                        .padding(.horizontal)
                    }
                    
                    // Already Premium State
                    if premiumManager.isPremium {
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
                    
                    
                    // Restore Purchases (always show for troubleshooting)  
                    Button("Restore Purchases") {
                        premiumManager.restorePurchases()
                    }
                    .foregroundColor(.pilotBlue)
                    .disabled(premiumManager.isLoading)
                    
                    Spacer(minLength: 20)
                }
            }
            .navigationTitle("Premium")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(.pilotBlue)
            )
            .onAppear {
                MixpanelManager.shared.trackPremiumViewShown(source: "navigation")
            }
        }
    }
}

// MARK: - Premium Feature Row
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
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
            
            if isHighlighted {
                Image(systemName: "checkmark.circle.fill")
                    .font(.title3)
                    .foregroundColor(.green)
            }
        }
        .padding()
        .background(isHighlighted ? Color.pilotBlue.opacity(0.05) : Color.clear)
        .cornerRadius(12)
    }
}