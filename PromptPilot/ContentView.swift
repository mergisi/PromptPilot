//
//  ContentView.swift
//  PromptPilot
//
//  Created by mustafa ergisi on 8/4/25.
//

import SwiftUI
import UIKit

// MARK: - Color Extension
extension Color {
    static let pilotBlue = Color(hex: "#4A90E2")
    static let lightBlue = Color(hex: "#7BB3F2")
    static var background: Color {
        Color(UIColor { trait in
            if trait.userInterfaceStyle == .dark {
                return UIColor.systemBackground // Uses system background in dark mode for readability
            } else {
                return UIColor(red: 240/255, green: 248/255, blue: 255/255, alpha: 1) // Light blue in light mode
            }
        })
    }
    
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Tab Views
struct PromptsView: View {
    @EnvironmentObject var promptStore: PromptStore
    @EnvironmentObject var premiumManager: PremiumManager
    @State private var searchText = ""
    @State private var selectedFilter: FilterOption = .all
    @State private var showingFilterSheet = false
    @State private var showingImportSheet = false
    
    private var filteredPrompts: [Prompt] {
        var prompts = promptStore.prompts
        
        // Apply search filter
        if !searchText.isEmpty {
            prompts = prompts.filter { prompt in
                prompt.title.localizedCaseInsensitiveContains(searchText) ||
                prompt.category.localizedCaseInsensitiveContains(searchText) ||
                prompt.tags.contains { $0.localizedCaseInsensitiveContains(searchText) } ||
                prompt.recommendedAI.contains { $0.localizedCaseInsensitiveContains(searchText) }
            }
        }
        
        // Apply category/AI filter
        switch selectedFilter {
        case .category(let category):
            prompts = prompts.filter { $0.category == category }
        case .aiModel(let model):
            prompts = prompts.filter { $0.recommendedAI.contains(model) }
        case .favorites:
            prompts = prompts.filter { $0.isFavorite }
        case .all:
            break
        }
        
        return prompts
    }
    
    private var categories: [String] {
        let set = Set(promptStore.prompts.map { $0.category })
        return Array(set).sorted()
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search and Filter Header
                VStack(spacing: 12) {
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.secondary)
                        TextField("Search prompts, categories, tags...", text: $searchText)
                        
                        if !searchText.isEmpty {
                            Button("Clear") {
                                searchText = ""
                            }
                            .foregroundColor(.pilotBlue)
                        }
                    }
                    .padding(12)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                    
                    HStack {
                        Text(selectedFilter.displayName)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Button("Filter") {
                            showingFilterSheet = true
                        }
                        .font(.subheadline)
                        .foregroundColor(.pilotBlue)
                    }
                }
                .padding()
                .background(Color.background)
                
                // Results
                if filteredPrompts.isEmpty {
                    VStack(spacing: 16) {
                        Spacer()
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 50))
                            .foregroundColor(.secondary)
                        Text("No prompts found")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                        Text("Try adjusting your search or filters")
                            .font(.body)
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                } else {
                    List(filteredPrompts) { prompt in
                        NavigationLink(destination: PromptDetailView(prompt: prompt)) {
                            PromptRowView(prompt: prompt)
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Prompts")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingImportSheet = true }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.pilotBlue)
                    }
                }
            }
        }
        .background(Color.background)
        .sheet(isPresented: $showingFilterSheet) {
            FilterSheetView(selectedFilter: $selectedFilter, categories: categories)
        }
        .sheet(isPresented: $showingImportSheet) {
            ImportPromptView()
                .environmentObject(promptStore)
                .environmentObject(premiumManager)
        }
    }
}

// MARK: - Filter Options
enum FilterOption: Equatable {
    case all
    case category(String)
    case aiModel(String)
    case favorites
    
    var displayName: String {
        switch self {
        case .all:
            return "All Prompts"
        case .category(let category):
            return "Category: \(category)"
        case .aiModel(let model):
            return "AI: \(model)"
        case .favorites:
            return "Favorites"
        }
    }
}

// MARK: - Prompt Row View
struct PromptRowView: View {
    let prompt: Prompt
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(prompt.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Spacer()
                
                if prompt.isFavorite {
                    Image(systemName: "heart.fill")
                        .foregroundColor(.red)
                        .font(.caption)
                }
            }
            
            Text(prompt.content)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(2)
            
            HStack {
                Text(prompt.category)
                    .font(.caption)
                    .fontWeight(.medium)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.pilotBlue.opacity(0.1))
                    .foregroundColor(.pilotBlue)
                    .cornerRadius(6)
                
                ForEach(prompt.recommendedAI.prefix(2), id: \.self) { ai in
                    Text(ai)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(4)
                }
                
                Spacer()
            }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Filter Sheet
struct FilterSheetView: View {
    @Binding var selectedFilter: FilterOption
    let categories: [String]
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            List {
                Section("Show") {
                    FilterRowView(
                        title: "All Prompts",
                        isSelected: selectedFilter == .all
                    ) {
                        selectedFilter = .all
                        presentationMode.wrappedValue.dismiss()
                    }
                    
                    FilterRowView(
                        title: "Favorites",
                        isSelected: selectedFilter == .favorites
                    ) {
                        selectedFilter = .favorites
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                
                Section("Categories") {
                    ForEach(categories, id: \.self) { category in
                        FilterRowView(
                            title: category,
                            isSelected: selectedFilter == .category(category)
                        ) {
                            selectedFilter = .category(category)
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
                
                Section("AI Models") {
                    FilterRowView(
                        title: "ChatGPT",
                        isSelected: selectedFilter == .aiModel("ChatGPT")
                    ) {
                        selectedFilter = .aiModel("ChatGPT")
                        presentationMode.wrappedValue.dismiss()
                    }
                    
                    FilterRowView(
                        title: "Claude",
                        isSelected: selectedFilter == .aiModel("Claude")
                    ) {
                        selectedFilter = .aiModel("Claude")
                        presentationMode.wrappedValue.dismiss()
                    }
                    
                    FilterRowView(
                        title: "Sora 2",
                        isSelected: selectedFilter == .aiModel("Sora 2")
                    ) {
                        selectedFilter = .aiModel("Sora 2")
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .navigationTitle("Filter")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct FilterRowView: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .foregroundColor(.primary)
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(.pilotBlue)
                }
            }
        }
    }
}

struct PromptListView: View {
    let category: String
    private var prompts: [Prompt] {
        Prompt.samplePrompts.filter { $0.category == category }
    }
    var body: some View {
        List(prompts) { prompt in
            NavigationLink(destination: PromptDetailView(prompt: prompt)) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(prompt.title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                    Text(prompt.content)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                .padding(.vertical, 4)
            }
        }
        .listStyle(.plain)
        .navigationTitle(category)
        .background(Color.background)
    }
}

// MARK: - Prompt Detail View
struct PromptDetailView: View {
    let prompt: Prompt
    @EnvironmentObject var promptStore: PromptStore
    @EnvironmentObject var premiumManager: PremiumManager
    @Environment(\.dismiss) private var dismiss
    @State private var showCopyConfirmation = false
    @State private var showingCollectionPicker = false
    @State private var showingPremiumView = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Category Badge
                HStack {
                    Text(prompt.category)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.pilotBlue.opacity(0.1))
                        .foregroundColor(.pilotBlue)
                        .cornerRadius(12)
                    Spacer()
                }
                
                // Title
                Text(prompt.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                // Content
                Text(prompt.content)
                    .font(.body)
                    .foregroundColor(.primary)
                    .lineSpacing(4)
                
                Spacer(minLength: 20)
                
                // Action Buttons
                VStack(spacing: 12) {
                    Button(action: copyToClipboard) {
                        HStack {
                            Image(systemName: "doc.on.doc")
                            Text("Copy to Clipboard")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.pilotBlue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    
                    Button(action: { showingCollectionPicker = true }) {
                        HStack {
                            Image(systemName: "folder.badge.plus")
                            Text("Add to Collection")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.pilotBlue.opacity(0.9))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    
                    HStack(spacing: 12) {
                        Button(action: openInChatGPT) {
                            Text("ChatGPT")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color.lightBlue)
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                        
                        Button(action: openInClaude) {
                            Text("Claude")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color.orange.opacity(0.9))
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                        
                        Button(action: openInGemini) {
                            Text("Gemini")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 12)
                                .background(Color.purple.opacity(0.9))
                                .foregroundColor(.white)
                                .cornerRadius(12)
                        }
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .background(Color.background)
        .navigationTitle("Prompt Details")
        .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                HStack {
                    Button(action: toggleFavorite) {
                        Image(systemName: promptStore.isFavorite(promptId: prompt.id) ? "heart.fill" : "heart")
                            .foregroundColor(promptStore.isFavorite(promptId: prompt.id) ? .red : .pilotBlue)
                    }
                    
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(.pilotBlue)
                }
            }
        }
        .overlay(
            Group {
                if showCopyConfirmation {
                    VStack {
                        Spacer()
                        Text("Copied to clipboard!")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .padding()
                            .background(Color.black.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .padding(.bottom, 100)
                    }
                    .transition(.opacity)
                }
            }
        )
        .sheet(isPresented: $showingCollectionPicker) {
            CollectionPickerSheet(prompt: prompt)
        }
        .sheet(isPresented: $showingPremiumView) {
            PremiumView()
        }
    }
    
    private func toggleFavorite() {
        let currentFavoriteCount = promptStore.getFavoritePrompts().count
        let isCurrentlyFavorite = promptStore.isFavorite(promptId: prompt.id)
        
        // If trying to add to favorites and would exceed limit
        if !isCurrentlyFavorite && !premiumManager.canAddFavorite(currentCount: currentFavoriteCount) {
            // Track limit reached
            MixpanelManager.shared.trackFavoriteLimitReached(currentCount: currentFavoriteCount)
            showingPremiumView = true
            return
        }
        
        // Track favorite toggle
        MixpanelManager.shared.trackFavoriteToggled(
            promptId: prompt.id.uuidString,
            promptTitle: prompt.title,
            category: prompt.category,
            isAdding: !isCurrentlyFavorite
        )
        
        promptStore.toggleFavorite(for: prompt.id)
        
        // Haptic feedback
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
    }
    
    private func copyToClipboard() {
        UIPasteboard.general.string = prompt.content
        
        // Track prompt copied
        MixpanelManager.shared.trackPromptCopied(
            promptId: prompt.id.uuidString,
            promptTitle: prompt.title,
            category: prompt.category
        )
        
        // Haptic feedback
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
        
        withAnimation(.easeInOut(duration: 0.3)) {
            showCopyConfirmation = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation(.easeInOut(duration: 0.3)) {
                showCopyConfirmation = false
            }
        }
    }
    
    private func openInChatGPT() {
        let encodedPrompt = prompt.content.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        // Track prompt shared to AI
        MixpanelManager.shared.trackPromptSharedToAI(
            promptId: prompt.id.uuidString,
            promptTitle: prompt.title,
            category: prompt.category,
            aiModel: "ChatGPT"
        )
        
        // Try ChatGPT app first
        if let appURL = URL(string: "chatgpt://chat?prompt=\(encodedPrompt)"),
           UIApplication.shared.canOpenURL(appURL) {
            UIApplication.shared.open(appURL)
        } else if let webURL = URL(string: "https://chat.openai.com/?model=gpt-4&q=\(encodedPrompt)") {
            UIApplication.shared.open(webURL)
        }
        
        // Haptic feedback
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
    }
    
    private func openInClaude() {
        let encodedPrompt = prompt.content.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        // Track prompt shared to AI
        MixpanelManager.shared.trackPromptSharedToAI(
            promptId: prompt.id.uuidString,
            promptTitle: prompt.title,
            category: prompt.category,
            aiModel: "Claude"
        )
        
        // Copy to clipboard for easy pasting
        UIPasteboard.general.string = prompt.content
        
        // Try Claude iOS app first with proper URL scheme
        if let appURL = URL(string: "claude://new?text=\(encodedPrompt)"),
           UIApplication.shared.canOpenURL(appURL) {
            UIApplication.shared.open(appURL)
        } else {
            // Fallback to Claude web
            if let webURL = URL(string: "https://claude.ai/new") {
                UIApplication.shared.open(webURL)
            }
        }
        
        // Haptic feedback
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
    }
    
    private func openInGemini() {
        let encodedPrompt = prompt.content.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        // Track prompt shared to AI
        MixpanelManager.shared.trackPromptSharedToAI(
            promptId: prompt.id.uuidString,
            promptTitle: prompt.title,
            category: prompt.category,
            aiModel: "Gemini"
        )
        
        // Copy to clipboard for easy pasting
        UIPasteboard.general.string = prompt.content
        
        // Try Google AI Studio / Gemini app first
        if let appURL = URL(string: "googleassistant://send?text=\(encodedPrompt)"),
           UIApplication.shared.canOpenURL(appURL) {
            UIApplication.shared.open(appURL)
        } else if let appURL = URL(string: "gemini://prompt?text=\(encodedPrompt)"),
                  UIApplication.shared.canOpenURL(appURL) {
            UIApplication.shared.open(appURL)
        } else {
            // Fallback to Gemini web (Google AI Studio)
            if let webURL = URL(string: "https://gemini.google.com/app") {
                UIApplication.shared.open(webURL)
            }
        }
        
        // Haptic feedback
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
    }
}

struct FavoritesView: View {
    @EnvironmentObject var promptStore: PromptStore
    @EnvironmentObject var premiumManager: PremiumManager
    @State private var showingNewCollectionSheet = false
    @State private var showingPremiumView = false
    
    var body: some View {
        NavigationView {
            List {
                if !promptStore.getFavoritePrompts().isEmpty {
                    Section("Favorite Prompts") {
                        ForEach(promptStore.getFavoritePrompts()) { prompt in
                            NavigationLink(destination: PromptDetailView(prompt: prompt)) {
                                PromptRowView(prompt: prompt)
                            }
                        }
                    }
                }
                
                Section(header: HStack {
                    Text("Collections")
                    Spacer()
                    Button("New") {
                        showingNewCollectionSheet = true
                    }
                    .font(.subheadline)
                    .foregroundColor(.pilotBlue)
                }) {
                    ForEach(promptStore.collections) { collection in
                        NavigationLink(destination: CollectionDetailView(collection: collection)) {
                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    Text(collection.name)
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.primary)
                                    
                                    Spacer()
                                    
                                    Text("\(collection.promptIds.count)")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color.gray.opacity(0.1))
                                        .cornerRadius(6)
                                }
                                
                                Text(collection.description)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .lineLimit(2)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            let collection = promptStore.collections[index]
                            promptStore.deleteCollection(collection.id)
                        }
                    }
                }
                
                if promptStore.getFavoritePrompts().isEmpty && promptStore.collections.isEmpty {
                    VStack(spacing: 16) {
                        Image(systemName: "heart")
                            .font(.system(size: 50))
                            .foregroundColor(.secondary)
                        Text("No favorites yet")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.secondary)
                        Text("Bookmark prompts and create collections to organize your favorites")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.vertical, 40)
                }
            }
            .navigationTitle("Favorites")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        if premiumManager.canCreateCollection(currentCount: promptStore.collections.count) {
                            showingNewCollectionSheet = true
                        } else {
                            // Track collection limit reached
                            MixpanelManager.shared.trackCollectionLimitReached(currentCount: promptStore.collections.count)
                            showingPremiumView = true
                        }
                    }) {
                        Image(systemName: "plus")
                            .foregroundColor(.pilotBlue)
                    }
                }
            }
        }
        .background(Color.background)
        .sheet(isPresented: $showingNewCollectionSheet) {
            NewCollectionSheet()
        }
        .sheet(isPresented: $showingPremiumView) {
            PremiumView()
        }
    }
}

struct LearnView: View {
    @State private var selectedTab = 0
    @StateObject private var challengeManager = DailyChallengeManager.shared
    private let templates = Template.sampleTemplates
    private let techniques = PromptTechnique.sampleTechniques
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Tab Selector
                Picker("Learn", selection: $selectedTab) {
                    Text("Templates").tag(0)
                    Text("Techniques").tag(1)
                    Text("Daily Challenge").tag(2)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .background(Color.background)
                
                // Content based on selected tab
                if selectedTab == 0 {
                    // Templates Tab
                    VStack(spacing: 8) {
                        VStack(spacing: 4) {
                            Text("Ready-to-Use Templates")
                                .font(.headline)
                                .foregroundColor(.primary)
                            Text("Fill-in-the-blank prompt builders")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal)
                        
                        List(templates) { template in
                            NavigationLink(destination: TemplateBuilderView(template: template)) {
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Text(template.title)
                                            .font(.headline)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.primary)
                                        
                                        Spacer()
                                        
                                        Text(template.category)
                                            .font(.caption)
                                            .fontWeight(.medium)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(Color.pilotBlue.opacity(0.1))
                                            .foregroundColor(.pilotBlue)
                                            .cornerRadius(6)
                                    }
                                    
                                    Text(template.description)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                        .lineLimit(2)
                                    
                                    HStack {
                                        Image(systemName: "square.and.pencil")
                                            .foregroundColor(.pilotBlue)
                                            .font(.caption)
                                        Text("\(template.placeholders.count) fields to customize")
                                            .font(.caption)
                                            .foregroundColor(.pilotBlue)
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                        }
                        .listStyle(PlainListStyle())
                    }
                } else if selectedTab == 1 {
                    // Techniques Tab
                    VStack(spacing: 8) {
                        VStack(spacing: 4) {
                            Text("Prompting Techniques")
                                .font(.headline)
                                .foregroundColor(.primary)
                            Text("Beginner to advanced strategies with examples")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .padding(.horizontal)
                        
                        List(techniques) { technique in
                            NavigationLink(destination: TechniqueDetailView(technique: technique)) {
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Text(technique.name)
                                            .font(.headline)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.primary)
                                        
                                        Spacer()
                                        
                                        HStack(spacing: 4) {
                                            Image(systemName: levelIcon(for: technique.level))
                                                .font(.caption)
                                            Text(technique.level)
                                                .font(.caption)
                                                .fontWeight(.medium)
                                        }
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(levelColor(for: technique.level).opacity(0.1))
                                        .foregroundColor(levelColor(for: technique.level))
                                        .cornerRadius(6)
                                    }
                                    
                                    Text(technique.description)
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                        .lineLimit(2)
                                    
                                    Text(technique.category)
                                        .font(.caption)
                                        .foregroundColor(.pilotBlue)
                                }
                                .padding(.vertical, 4)
                            }
                        }
                        .listStyle(PlainListStyle())
                    }
                } else {
                    // Daily Challenge Tab
                    ScrollView {
                        VStack(spacing: 20) {
                            // Header
                            VStack(spacing: 8) {
                                Image(systemName: "trophy.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.yellow)
                                
                                Text("Daily Challenge")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                
                                Text("Practice your prompting skills")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.top)
                            
                            if let challenge = challengeManager.todaysChallenge {
                                ChallengeCardView(challenge: challenge)
                            } else {
                                Text("Loading today's challenge...")
                                    .foregroundColor(.secondary)
                            }
                            
                            // Past Challenges
                            if !challengeManager.pastChallenges.isEmpty {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Previous Challenges")
                                        .font(.headline)
                                        .padding(.horizontal)
                                    
                                    ForEach(challengeManager.pastChallenges.prefix(5)) { challenge in
                                        NavigationLink(destination: ChallengeDetailView(challenge: challenge)) {
                                            HStack {
                                                VStack(alignment: .leading, spacing: 4) {
                                                    Text(challenge.title)
                                                        .font(.subheadline)
                                                        .fontWeight(.medium)
                                                        .foregroundColor(.primary)
                                                    Text(formatDate(challenge.date))
                                                        .font(.caption)
                                                        .foregroundColor(.secondary)
                                                }
                                                Spacer()
                                                Image(systemName: "chevron.right")
                                                    .font(.caption)
                                                    .foregroundColor(.secondary)
                                            }
                                            .padding()
                                            .background(Color.gray.opacity(0.05))
                                            .cornerRadius(10)
                                        }
                                        .padding(.horizontal)
                                    }
                                }
                            }
                        }
                        .padding(.bottom)
                    }
                }
            }
            .navigationTitle("Learn")
            .navigationBarTitleDisplayMode(.large)
            .background(Color.background)
        }
    }
    
    private func levelIcon(for level: String) -> String {
        switch level {
        case "Beginner": return "star"
        case "Intermediate": return "star.leadinghalf.filled"
        case "Advanced": return "star.fill"
        default: return "star"
        }
    }
    
    private func levelColor(for level: String) -> Color {
        switch level {
        case "Beginner": return .green
        case "Intermediate": return .orange
        case "Advanced": return .red
        default: return .pilotBlue
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

// MARK: - Template Builder View
struct TemplateBuilderView: View {
    let template: Template
    @State private var fieldValues: [String: String] = [:]
    @State private var showingCopyConfirmation = false
    @State private var showingPremiumSheet = false
    @EnvironmentObject var premiumManager: PremiumManager
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header
                VStack(alignment: .leading, spacing: 8) {
                    Text(template.category.uppercased())
                        .font(.caption)
                        .fontWeight(.medium)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(Color.pilotBlue.opacity(0.1))
                        .foregroundColor(.pilotBlue)
                        .cornerRadius(8)
                    
                    Text(template.title)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    Text(template.description)
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                
                // Input Fields
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Fill in the fields:")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        if !premiumManager.isPremium {
                            Spacer()
                            Button(action: { showingPremiumSheet = true }) {
                                HStack(spacing: 4) {
                                    Image(systemName: "crown.fill")
                                        .font(.caption)
                                    Text("Premium")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                }
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.yellow.opacity(0.2))
                                .foregroundColor(.orange)
                                .cornerRadius(6)
                            }
                        }
                    }
                    
                    if premiumManager.isPremium {
                        ForEach(template.placeholders, id: \.self) { placeholder in
                            VStack(alignment: .leading, spacing: 6) {
                                Text(placeholder.replacingOccurrences(of: "_", with: " ").capitalized)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.primary)
                                
                                TextField("Enter \(placeholder.lowercased())", text: Binding(
                                    get: { fieldValues[placeholder] ?? "" },
                                    set: { fieldValues[placeholder] = $0 }
                                ))
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                        }
                    } else {
                        // Show placeholder fields for non-premium users
                        ForEach(template.placeholders, id: \.self) { placeholder in
                            VStack(alignment: .leading, spacing: 6) {
                                Text(placeholder.replacingOccurrences(of: "_", with: " ").capitalized)
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                    .foregroundColor(.secondary)
                                
                                Button(action: { showingPremiumSheet = true }) {
                                    HStack {
                                        Text("Tap to unlock custom templates")
                                            .foregroundColor(.secondary)
                                        Spacer()
                                        Image(systemName: "lock.fill")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    .padding()
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(8)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                    )
                                }
                            }
                        }
                    }
                }
                
                // Preview
                VStack(alignment: .leading, spacing: 12) {
                    Text("Preview:")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    if premiumManager.isPremium {
                        Text(buildPrompt())
                            .font(.body)
                            .padding()
                            .background(Color.pilotBlue.opacity(0.05))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.pilotBlue.opacity(0.2), lineWidth: 1)
                            )
                    } else {
                        VStack(spacing: 12) {
                            Text(template.template)
                                .font(.body)
                                .foregroundColor(.secondary)
                                .padding()
                                .background(Color.gray.opacity(0.05))
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                )
                            
                            Button(action: { showingPremiumSheet = true }) {
                                HStack {
                                    Image(systemName: "wand.and.stars")
                                    Text("Unlock Custom Templates")
                                        .fontWeight(.semibold)
                                }
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.orange, Color.yellow]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(12)
                            }
                        }
                    }
                }
                
                // Action Buttons
                if premiumManager.isPremium {
                    VStack(spacing: 12) {
                        Button(action: copyPrompt) {
                            HStack {
                                Image(systemName: "doc.on.doc")
                                Text("Copy Prompt")
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.pilotBlue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                        
                        HStack(spacing: 12) {
                            Button(action: openInChatGPT) {
                                Text("ChatGPT")
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(Color.lightBlue)
                                    .foregroundColor(.white)
                                    .cornerRadius(12)
                            }
                            
                            Button(action: openInClaude) {
                                Text("Claude")
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(Color.orange.opacity(0.9))
                                    .foregroundColor(.white)
                                    .cornerRadius(12)
                            }
                            
                            Button(action: openInGemini) {
                                Text("Gemini")
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(Color.purple.opacity(0.9))
                                    .foregroundColor(.white)
                                    .cornerRadius(12)
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .background(Color.background)
        .navigationBarTitleDisplayMode(.inline)
        .overlay(
            // Copy confirmation toast
            Group {
                if showingCopyConfirmation {
                    VStack {
                        Spacer()
                        Text("Copied to clipboard!")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .padding()
                            .background(Color.black.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .padding(.bottom, 100)
                    }
                    .transition(.opacity)
                }
            }
        )
        .sheet(isPresented: $showingPremiumSheet) {
            PremiumView()
                .environmentObject(premiumManager)
        }
    }
    
    private func buildPrompt() -> String {
        var prompt = template.template
        for placeholder in template.placeholders {
            let value = fieldValues[placeholder] ?? "[\(placeholder)]"
            prompt = prompt.replacingOccurrences(of: "[\(placeholder)]", with: value)
        }
        return prompt
    }
    
    private func copyPrompt() {
        UIPasteboard.general.string = buildPrompt()
        
        // Show confirmation
        withAnimation(.easeInOut(duration: 0.3)) {
            showingCopyConfirmation = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation(.easeInOut(duration: 0.3)) {
                showingCopyConfirmation = false
            }
        }
        
        // Haptic feedback
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
    }
    
    private func openInChatGPT() {
        let prompt = buildPrompt()
        let encodedPrompt = prompt.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        if let appURL = URL(string: "chatgpt://chat?prompt=\(encodedPrompt)"), UIApplication.shared.canOpenURL(appURL) {
            UIApplication.shared.open(appURL)
        } else if let webURL = URL(string: "https://chat.openai.com/?model=gpt-4&q=\(encodedPrompt)") {
            UIApplication.shared.open(webURL)
        }
        
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
    }
    
    private func openInClaude() {
        let prompt = buildPrompt()
        let encodedPrompt = prompt.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        // Copy to clipboard for easy pasting
        UIPasteboard.general.string = prompt
        
        // Try Claude iOS app first with proper URL scheme
        if let appURL = URL(string: "claude://new?text=\(encodedPrompt)"),
           UIApplication.shared.canOpenURL(appURL) {
            UIApplication.shared.open(appURL)
        } else {
            // Fallback to Claude web
            if let webURL = URL(string: "https://claude.ai/new") {
                UIApplication.shared.open(webURL)
            }
        }
        
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
    }
    
    private func openInGemini() {
        let prompt = buildPrompt()
        let encodedPrompt = prompt.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        // Copy to clipboard for easy pasting
        UIPasteboard.general.string = prompt
        
        // Try Google AI Studio / Gemini app first
        if let appURL = URL(string: "googleassistant://send?text=\(encodedPrompt)"),
           UIApplication.shared.canOpenURL(appURL) {
            UIApplication.shared.open(appURL)
        } else if let appURL = URL(string: "gemini://prompt?text=\(encodedPrompt)"),
                  UIApplication.shared.canOpenURL(appURL) {
            UIApplication.shared.open(appURL)
        } else {
            // Fallback to Gemini web (Google AI Studio)
            if let webURL = URL(string: "https://gemini.google.com/app") {
                UIApplication.shared.open(webURL)
            }
        }
        
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
    }
}

// MARK: - Collection Views
struct CollectionPickerSheet: View {
    let prompt: Prompt
    @EnvironmentObject var promptStore: PromptStore
    @EnvironmentObject var premiumManager: PremiumManager
    @Environment(\.presentationMode) var presentationMode
    @State private var showingNewCollectionForm = false
    @State private var showingSuccessMessage = false
    @State private var showingPremiumView = false
    @State private var selectedCollectionName = ""
    
    var body: some View {
        NavigationView {
            VStack {
                if promptStore.collections.isEmpty {
                    VStack(spacing: 20) {
                        Spacer()
                        Image(systemName: "folder.badge.plus")
                            .font(.system(size: 60))
                            .foregroundColor(.secondary)
                        Text("No Collections Yet")
                            .font(.title2)
                            .fontWeight(.semibold)
                        Text("Create your first collection to organize prompts")
                            .font(.body)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        
                        Button("Create Collection") {
                            showingNewCollectionForm = true
                        }
                        .font(.headline)
                        .padding()
                        .background(Color.pilotBlue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        Spacer()
                    }
                    .padding()
                } else {
                    List {
                        Section("Select a Collection") {
                            ForEach(promptStore.collections) { collection in
                                Button(action: {
                                    addToCollection(collection)
                                }) {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(collection.name)
                                                .font(.headline)
                                                .foregroundColor(.primary)
                                            Text(collection.description)
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                        Spacer()
                                        
                                        if collection.promptIds.contains(prompt.id) {
                                            Image(systemName: "checkmark.circle.fill")
                                                .foregroundColor(.green)
                                        } else {
                                            Text("\(collection.promptIds.count)")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                                .padding(.horizontal, 8)
                                                .padding(.vertical, 4)
                                                .background(Color.gray.opacity(0.1))
                                                .cornerRadius(6)
                                        }
                                    }
                                    .padding(.vertical, 4)
                                }
                            }
                        }
                        
                        Section {
                            Button(action: {
                                showingNewCollectionForm = true
                            }) {
                                HStack {
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundColor(.pilotBlue)
                                    Text("Create New Collection")
                                        .foregroundColor(.pilotBlue)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Add to Collection")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
            .sheet(isPresented: $showingNewCollectionForm) {
                NewCollectionSheet()
            }
            .sheet(isPresented: $showingPremiumView) {
                PremiumView()
            }
            .overlay(
                Group {
                    if showingSuccessMessage {
                        VStack {
                            Spacer()
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.green)
                                Text("Added to \(selectedCollectionName)")
                                    .fontWeight(.medium)
                            }
                            .padding()
                            .background(Color.black.opacity(0.8))
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .padding(.bottom, 50)
                        }
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
            )
        }
    }
    
    private func addToCollection(_ collection: Collection) {
        if !collection.promptIds.contains(prompt.id) {
            // Check collection limit
            if !premiumManager.canAddToCollection(currentCount: collection.promptIds.count) {
                showingPremiumView = true
                return
            }
            
            promptStore.addToCollection(collection.id, promptId: prompt.id)
            selectedCollectionName = collection.name
            
            // Show success message
            withAnimation(.easeInOut(duration: 0.3)) {
                showingSuccessMessage = true
            }
            
            // Haptic feedback
            let impact = UIImpactFeedbackGenerator(style: .medium)
            impact.impactOccurred()
            
            // Hide message and dismiss after delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                withAnimation(.easeInOut(duration: 0.3)) {
                    showingSuccessMessage = false
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    presentationMode.wrappedValue.dismiss()
                }
            }
        } else {
            // Already in collection - remove it
            promptStore.removeFromCollection(collection.id, promptId: prompt.id)
            
            // Haptic feedback
            let impact = UIImpactFeedbackGenerator(style: .light)
            impact.impactOccurred()
        }
    }
}

struct CollectionDetailView: View {
    let collection: Collection
    @EnvironmentObject var promptStore: PromptStore
    
    private var collectionPrompts: [Prompt] {
        promptStore.prompts.filter { prompt in
            collection.promptIds.contains(prompt.id)
        }
    }
    
    var body: some View {
        List {
            if collectionPrompts.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "folder")
                        .font(.system(size: 50))
                        .foregroundColor(.secondary)
                    Text("Empty Collection")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                    Text("Add prompts to this collection from the Prompts tab")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.vertical, 40)
            } else {
                ForEach(collectionPrompts) { prompt in
                    NavigationLink(destination: PromptDetailView(prompt: prompt)) {
                        PromptRowView(prompt: prompt)
                    }
                }
                .onDelete { indexSet in
                    for index in indexSet {
                        let prompt = collectionPrompts[index]
                        promptStore.removeFromCollection(collection.id, promptId: prompt.id)
                    }
                }
            }
        }
        .navigationTitle(collection.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if !collectionPrompts.isEmpty {
                    EditButton()
                }
            }
        }
    }
}

struct NewCollectionSheet: View {
    @EnvironmentObject var promptStore: PromptStore
    @EnvironmentObject var premiumManager: PremiumManager
    @State private var name = ""
    @State private var description = ""
    @Environment(\.presentationMode) var presentationMode
    @State private var showingPremiumView = false
    
    var body: some View {
        NavigationView {
            Form {
                Section("Collection Details") {
                    TextField("Collection Name", text: $name)
                    TextField("Description", text: $description)
                }
            }
            .navigationTitle("New Collection")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Create") {
                    if premiumManager.canCreateCollection(currentCount: promptStore.collections.count) {
                        promptStore.createCollection(name: name, description: description)
                        presentationMode.wrappedValue.dismiss()
                    } else {
                        showingPremiumView = true
                    }
                }
                .disabled(name.isEmpty)
            )
            .sheet(isPresented: $showingPremiumView) {
                PremiumView()
            }
        }
    }
}

// MARK: - Learning Detail Views
struct TechniqueDetailView: View {
    let technique: PromptTechnique
    @State private var showingExample = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Level Badge
                HStack {
                    Image(systemName: levelIcon(for: technique.level))
                        .font(.subheadline)
                    Text(technique.level)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(levelColor(for: technique.level).opacity(0.1))
                .foregroundColor(levelColor(for: technique.level))
                .cornerRadius(8)
                
                // Description
                VStack(alignment: .leading, spacing: 12) {
                    Text("Overview")
                        .font(.headline)
                    Text(technique.explanation)
                        .font(.body)
                        .foregroundColor(.primary)
                }
                
                // Example Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Example Prompt")
                        .font(.headline)
                    
                    Text(technique.example)
                        .font(.system(.body, design: .monospaced))
                        .padding()
                        .background(Color.pilotBlue.opacity(0.05))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.pilotBlue.opacity(0.2), lineWidth: 1)
                        )
                    
                    Button(action: { showingExample.toggle() }) {
                        HStack {
                            Text(showingExample ? "Hide Expected Output" : "Show Expected Output")
                                .fontWeight(.medium)
                            Image(systemName: showingExample ? "chevron.up" : "chevron.down")
                        }
                        .foregroundColor(.pilotBlue)
                    }
                    
                    if showingExample {
                        Text(technique.expectedOutput)
                            .font(.system(.body, design: .default))
                            .padding()
                            .background(Color.green.opacity(0.05))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.green.opacity(0.2), lineWidth: 1)
                            )
                            .transition(.opacity)
                    }
                }
                
                // Tips Section
                VStack(alignment: .leading, spacing: 12) {
                    Text("Pro Tips")
                        .font(.headline)
                    
                    ForEach(technique.tips, id: \.self) { tip in
                        HStack(alignment: .top, spacing: 8) {
                            Image(systemName: "lightbulb.fill")
                                .foregroundColor(.yellow)
                                .font(.caption)
                            Text(tip)
                                .font(.subheadline)
                                .foregroundColor(.primary)
                        }
                    }
                }
                
                // Copy Button
                Button(action: copyExample) {
                    HStack {
                        Image(systemName: "doc.on.doc")
                        Text("Copy Example Prompt")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.pilotBlue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
            }
            .padding()
        }
        .navigationTitle(technique.name)
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.background)
    }
    
    private func copyExample() {
        UIPasteboard.general.string = technique.example
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
    }
    
    private func levelIcon(for level: String) -> String {
        switch level {
        case "Beginner": return "star"
        case "Intermediate": return "star.leadinghalf.filled"
        case "Advanced": return "star.fill"
        default: return "star"
        }
    }
    
    private func levelColor(for level: String) -> Color {
        switch level {
        case "Beginner": return .green
        case "Intermediate": return .orange
        case "Advanced": return .red
        default: return .pilotBlue
        }
    }
}

struct ChallengeCardView: View {
    let challenge: DailyChallenge
    
    var body: some View {
        NavigationLink(destination: ChallengeDetailView(challenge: challenge)) {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Today's Challenge")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text(challenge.title)
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                    }
                    
                    Spacer()
                    
                    Text(challenge.difficulty)
                        .font(.caption)
                        .fontWeight(.medium)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(difficultyColor(challenge.difficulty).opacity(0.1))
                        .foregroundColor(difficultyColor(challenge.difficulty))
                        .cornerRadius(6)
                }
                
                Text(challenge.description)
                    .font(.body)
                    .foregroundColor(.secondary)
                
                HStack {
                    Image(systemName: "arrow.right.circle.fill")
                        .foregroundColor(.pilotBlue)
                    Text("Start Challenge")
                        .fontWeight(.semibold)
                        .foregroundColor(.pilotBlue)
                }
            }
            .padding()
            .background(Color.pilotBlue.opacity(0.05))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.pilotBlue.opacity(0.2), lineWidth: 1)
            )
        }
        .padding(.horizontal)
    }
    
    private func difficultyColor(_ difficulty: String) -> Color {
        switch difficulty {
        case "Beginner": return .green
        case "Intermediate": return .orange
        case "Advanced": return .red
        default: return .pilotBlue
        }
    }
}

struct ChallengeDetailView: View {
    let challenge: DailyChallenge
    @State private var userResponse = ""
    @State private var showingHints = false
    @State private var showingSolution = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Challenge Header
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(challenge.difficulty)
                            .font(.caption)
                            .fontWeight(.medium)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(difficultyColor(challenge.difficulty).opacity(0.1))
                            .foregroundColor(difficultyColor(challenge.difficulty))
                            .cornerRadius(6)
                        
                        Spacer()
                        
                        Text(formatDate(challenge.date))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    Text(challenge.title)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text(challenge.description)
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                
                // The Challenge
                VStack(alignment: .leading, spacing: 12) {
                    Text("Your Challenge")
                        .font(.headline)
                    
                    Text(challenge.prompt)
                        .font(.body)
                        .padding()
                        .background(Color.pilotBlue.opacity(0.05))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.pilotBlue.opacity(0.2), lineWidth: 1)
                        )
                }
                
                // User Response Area
                VStack(alignment: .leading, spacing: 12) {
                    Text("Your Response")
                        .font(.headline)
                    
                    TextEditor(text: $userResponse)
                        .frame(minHeight: 150)
                        .padding(8)
                        .background(Color.gray.opacity(0.05))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                }
                
                // Hints Section
                VStack(alignment: .leading, spacing: 12) {
                    Button(action: { showingHints.toggle() }) {
                        HStack {
                            Image(systemName: "lightbulb")
                            Text(showingHints ? "Hide Hints" : "Show Hints")
                                .fontWeight(.medium)
                            Spacer()
                            Image(systemName: showingHints ? "chevron.up" : "chevron.down")
                        }
                        .foregroundColor(.orange)
                    }
                    
                    if showingHints {
                        VStack(alignment: .leading, spacing: 8) {
                            ForEach(challenge.hints, id: \.self) { hint in
                                HStack(alignment: .top, spacing: 8) {
                                    Text("•")
                                        .foregroundColor(.orange)
                                    Text(hint)
                                        .font(.subheadline)
                                        .foregroundColor(.primary)
                                }
                            }
                        }
                        .padding()
                        .background(Color.orange.opacity(0.05))
                        .cornerRadius(8)
                        .transition(.opacity)
                    }
                }
                
                // Solution Section
                VStack(alignment: .leading, spacing: 12) {
                    Button(action: { showingSolution.toggle() }) {
                        HStack {
                            Image(systemName: "checkmark.circle")
                            Text(showingSolution ? "Hide Solution" : "Show Sample Solution")
                                .fontWeight(.medium)
                            Spacer()
                            Image(systemName: showingSolution ? "chevron.up" : "chevron.down")
                        }
                        .foregroundColor(.green)
                    }
                    
                    if showingSolution {
                        Text(challenge.sampleSolution)
                            .font(.body)
                            .padding()
                            .background(Color.green.opacity(0.05))
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.green.opacity(0.2), lineWidth: 1)
                            )
                            .transition(.opacity)
                    }
                }
                
                // Copy Challenge Button
                Button(action: copyChallenge) {
                    HStack {
                        Image(systemName: "doc.on.doc")
                        Text("Copy Challenge Prompt")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.pilotBlue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
            }
            .padding()
        }
        .navigationTitle("Challenge")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.background)
    }
    
    private func copyChallenge() {
        UIPasteboard.general.string = challenge.prompt
        let impact = UIImpactFeedbackGenerator(style: .medium)
        impact.impactOccurred()
    }
    
    private func difficultyColor(_ difficulty: String) -> Color {
        switch difficulty {
        case "Beginner": return .green
        case "Intermediate": return .orange
        case "Advanced": return .red
        default: return .pilotBlue
        }
    }
    
    private func formatDate(_ date: Date) -> String {
    let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

// MARK: - Content View
struct ContentView: View {
    @StateObject private var promptStore = PromptStore.shared
    @StateObject private var premiumManager = PremiumManager.shared
    
    var body: some View {
        TabView {
            VStack(spacing: 0) {
                PromptsView()
                BannerAdContainer()
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("Prompts")
            }
            
            VStack(spacing: 0) {
                FavoritesView()
                BannerAdContainer()
            }
            .tabItem {
                Image(systemName: "heart.fill")
                Text("Favorites")
            }
            
            VStack(spacing: 0) {
                LearnView()
                BannerAdContainer()
            }
            .tabItem {
                Image(systemName: "book.fill")
                Text("Learn")
            }
        }
        .tint(.pilotBlue)
        .environmentObject(promptStore)
        .environmentObject(premiumManager)
    }
}

// MARK: - Import Prompt View
struct ImportPromptView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var promptStore: PromptStore
    @EnvironmentObject var premiumManager: PremiumManager
    @State private var importText = ""
    @State private var detectedTitle = ""
    @State private var detectedCategory = "Business"
    @State private var detectedTags: [String] = []
    @State private var detectedAI: [String] = ["ChatGPT", "Claude"]
    @State private var isProcessing = false
    @State private var showingPremiumSheet = false
    
    private let categories = ["Business", "Writing", "Coding", "Creative", "Education", "Personal", "Marketing", "Health", "Finance", "Google Nano Banana", "Sora 2"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Import Prompt")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Text("Paste any prompt text and we'll help organize it")
                            .font(.body)
                            .foregroundColor(.secondary)
                    }
                    
                    // Premium Limit Warning
                    if !premiumManager.isPremium {
                        let importCount = promptStore.getImportedPromptsCount()
                        let remainingImports = max(0, PremiumManager.freeImportLimit - importCount)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: remainingImports > 0 ? "info.circle.fill" : "exclamationmark.triangle.fill")
                                    .foregroundColor(remainingImports > 0 ? .blue : .orange)
                                
                                if remainingImports > 0 {
                                    Text("Free imports remaining: \(remainingImports)/\(PremiumManager.freeImportLimit)")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                } else {
                                    Text("Import limit reached")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(.orange)
                                }
                                
                                Spacer()
                                
                                if remainingImports <= 1 {
                                    Button("Upgrade") {
                                        showingPremiumSheet = true
                                    }
                                    .font(.caption)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.yellow.opacity(0.2))
                                    .foregroundColor(.orange)
                                    .cornerRadius(8)
                                }
                            }
                            
                            if remainingImports == 0 {
                                Text("Upgrade to Premium for unlimited imports")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding()
                        .background(remainingImports > 0 ? Color.blue.opacity(0.05) : Color.orange.opacity(0.05))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(remainingImports > 0 ? Color.blue.opacity(0.2) : Color.orange.opacity(0.3), lineWidth: 1)
                        )
                    }
                    
                    // Import Text Area
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Prompt Text")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        TextEditor(text: $importText)
                            .frame(minHeight: 120)
                            .padding(12)
                            .background(Color.gray.opacity(0.05))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.pilotBlue.opacity(0.3), lineWidth: 1)
                            )
                            .onChange(of: importText) { _ in
                                processImportText()
                            }
                        
                        if importText.isEmpty {
                            Text("Paste your prompt here...")
                                .font(.body)
                                .foregroundColor(.secondary)
                                .padding(.top, -100)
                                .allowsHitTesting(false)
                        }
                    }
                    
                    // Auto-detected Information
                    if !importText.isEmpty {
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Auto-detected Information")
                                .font(.headline)
                                .fontWeight(.semibold)
                            
                            // Title
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Title")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                
                                TextField("Enter title", text: $detectedTitle)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                            
                            // Category
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Category")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                
                                Picker("Category", selection: $detectedCategory) {
                                    ForEach(categories, id: \.self) { category in
                                        Text(category).tag(category)
                                    }
                                }
                                .pickerStyle(MenuPickerStyle())
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(12)
                                .background(Color.gray.opacity(0.05))
                                .cornerRadius(8)
                            }
                            
                            // Tags
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Suggested Tags")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                
                                LazyVGrid(columns: [
                                    GridItem(.adaptive(minimum: 80))
                                ], spacing: 8) {
                                    ForEach(detectedTags, id: \.self) { tag in
                                        Text(tag)
                                            .font(.caption)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(Color.pilotBlue.opacity(0.1))
                                            .foregroundColor(.pilotBlue)
                                            .cornerRadius(6)
                                    }
                                }
                            }
                            
                            // AI Models
                            VStack(alignment: .leading, spacing: 6) {
                                Text("Recommended AI Models")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                
                                HStack {
                                    ForEach(detectedAI, id: \.self) { ai in
                                        Text(ai)
                                            .font(.caption)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(Color.green.opacity(0.1))
                                            .foregroundColor(.green)
                                            .cornerRadius(6)
                                    }
                                }
                            }
                        }
                        .padding()
                        .background(Color.pilotBlue.opacity(0.05))
                        .cornerRadius(12)
                    }
                    
                    // Import Button
                    Button(action: handleImportTap) {
                        HStack {
                            if isProcessing {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(0.8)
                            } else {
                                Image(systemName: "plus.circle.fill")
                            }
                            Text(isProcessing ? "Importing..." : "Import Prompt")
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(importText.isEmpty ? Color.gray : Color.pilotBlue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    .disabled(importText.isEmpty || isProcessing)
                }
                .padding()
            }
            .navigationTitle("Import")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
        .sheet(isPresented: $showingPremiumSheet) {
            PremiumView()
                .environmentObject(premiumManager)
        }
    }
    
    private func processImportText() {
        guard !importText.isEmpty else {
            detectedTitle = ""
            detectedTags = []
            return
        }
        
        // Auto-detect title from first line or common patterns
        let lines = importText.components(separatedBy: .newlines).filter { !$0.isEmpty }
        if let firstLine = lines.first {
            if firstLine.count < 100 && !firstLine.contains("[") {
                detectedTitle = firstLine.trimmingCharacters(in: .whitespacesAndNewlines)
            } else {
                // Extract title from common prompt patterns
                if importText.lowercased().contains("act as") {
                    detectedTitle = "Act as Assistant"
                } else if importText.lowercased().contains("write") {
                    detectedTitle = "Writing Assistant"
                } else if importText.lowercased().contains("create") {
                    detectedTitle = "Creative Assistant"
                } else {
                    detectedTitle = "Custom Prompt"
                }
            }
        }
        
        // Auto-detect category based on keywords
        let text = importText.lowercased()
        if text.contains("business") || text.contains("marketing") || text.contains("sales") || text.contains("meeting") {
            detectedCategory = "Business"
        } else if text.contains("code") || text.contains("programming") || text.contains("debug") || text.contains("algorithm") {
            detectedCategory = "Coding"
        } else if text.contains("write") || text.contains("blog") || text.contains("article") || text.contains("content") {
            detectedCategory = "Writing"
        } else if text.contains("creative") || text.contains("story") || text.contains("character") || text.contains("art") {
            detectedCategory = "Creative"
        } else if text.contains("learn") || text.contains("teach") || text.contains("study") || text.contains("education") {
            detectedCategory = "Education"
        } else if text.contains("health") || text.contains("fitness") || text.contains("workout") || text.contains("meal") {
            detectedCategory = "Health"
        } else if text.contains("money") || text.contains("investment") || text.contains("budget") || text.contains("finance") {
            detectedCategory = "Finance"
        } else if text.contains("personal") || text.contains("goal") || text.contains("habit") || text.contains("resume") {
            detectedCategory = "Personal"
        } else if text.contains("video") || text.contains("cinematic") || text.contains("camera") || text.contains("shot") || text.contains("scene") || text.contains("sora") {
            detectedCategory = "Sora 2"
        } else if text.contains("image") || text.contains("photo") || text.contains("generate") || text.contains("picture") {
            detectedCategory = "Google Nano Banana"
        }
        
        // Auto-detect tags
        var tags: [String] = []
        let commonTags = [
            "productivity", "creative", "business", "writing", "coding", "analysis",
            "strategy", "planning", "marketing", "education", "personal", "health"
        ]
        
        for tag in commonTags {
            if text.contains(tag) {
                tags.append(tag)
            }
        }
        
        detectedTags = Array(Set(tags)).prefix(5).map { $0 }
        
        // Auto-detect AI models
        if text.contains("video") || text.contains("cinematic") || text.contains("camera") || text.contains("shot") || text.contains("scene") || text.contains("sora") {
            detectedAI = ["Sora 2"]
        } else if text.contains("image") || text.contains("photo") || text.contains("generate picture") {
            detectedAI = ["Gemini"]
        } else if text.contains("creative") || text.contains("story") || text.contains("poetry") {
            detectedAI = ["Claude", "ChatGPT"]
        } else {
            detectedAI = ["ChatGPT", "Claude"]
        }
    }
    
    private func handleImportTap() {
        let importCount = promptStore.getImportedPromptsCount()
        
        if premiumManager.canImportPrompt(currentCount: importCount) {
            importPrompt()
        } else {
            // Track import limit reached
            MixpanelManager.shared.trackImportLimitReached(currentCount: importCount)
            showingPremiumSheet = true
        }
    }
    
    private func importPrompt() {
        isProcessing = true
        
        // Create new prompt
        let newPrompt = Prompt(
            title: detectedTitle.isEmpty ? "Imported Prompt" : detectedTitle,
            content: importText,
            category: detectedCategory,
            tags: detectedTags,
            recommendedAI: detectedAI
        )
        
        // Track imported prompt
        MixpanelManager.shared.trackPromptImported(
            promptId: newPrompt.id.uuidString,
            promptTitle: newPrompt.title,
            category: newPrompt.category,
            method: "manual"
        )
        
        // Add to prompt store using the new tracking method
        promptStore.addImportedPrompt(newPrompt)
        
        // Add slight delay for better UX
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            isProcessing = false
            presentationMode.wrappedValue.dismiss()
        }
    }
}

#Preview {
    ContentView()
}