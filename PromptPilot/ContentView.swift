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
    @State private var searchText = ""
    @State private var selectedFilter: FilterOption = .all
    @State private var showingFilterSheet = false
    
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
        }
        .background(Color.background)
        .sheet(isPresented: $showingFilterSheet) {
            FilterSheetView(selectedFilter: $selectedFilter, categories: categories)
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
    @Environment(\.dismiss) private var dismiss
    @State private var showCopyConfirmation = false
    @State private var showingCollectionPicker = false
    
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
    }
    
    private func toggleFavorite() {
        promptStore.toggleFavorite(for: prompt.id)
        
        // Haptic feedback
        let impact = UIImpactFeedbackGenerator(style: .light)
        impact.impactOccurred()
    }
    
    private func copyToClipboard() {
        UIPasteboard.general.string = prompt.content
        
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
    @State private var showingNewCollectionSheet = false
    
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
        }
        .background(Color.background)
        .sheet(isPresented: $showingNewCollectionSheet) {
            NewCollectionSheet()
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
                    Text("Fill in the fields:")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
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
                }
                
                // Preview
                VStack(alignment: .leading, spacing: 12) {
                    Text("Preview:")
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text(buildPrompt())
                        .font(.body)
                        .padding()
                        .background(Color.pilotBlue.opacity(0.05))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.pilotBlue.opacity(0.2), lineWidth: 1)
                        )
                }
                
                // Action Buttons
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
    @Environment(\.presentationMode) var presentationMode
    @State private var showingNewCollectionForm = false
    @State private var showingSuccessMessage = false
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
    @State private var name = ""
    @State private var description = ""
    @Environment(\.presentationMode) var presentationMode
    
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
                    promptStore.createCollection(name: name, description: description)
                    presentationMode.wrappedValue.dismiss()
                }
                .disabled(name.isEmpty)
            )
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
    
    var body: some View {
        TabView {
            PromptsView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Prompts")
                }
            
            FavoritesView()
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text("Favorites")
                }
            
            LearnView()
                .tabItem {
                    Image(systemName: "book.fill")
                    Text("Learn")
                }
        }
        .tint(.pilotBlue)
        .environmentObject(promptStore)
    }
}

#Preview {
    ContentView()
}