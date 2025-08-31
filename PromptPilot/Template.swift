//
//  Template.swift
//  PromptPilot
//
//  Created by PromptPilot AI Assistant on 8/4/25.
//

import Foundation

// MARK: - Template Model
struct Template: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let template: String
    let placeholders: [String] // Fields to fill in
    let category: String
}

// MARK: - Sample Templates
extension Template {
    static let sampleTemplates: [Template] = [
        // Business Templates
        Template(
            title: "Meeting Summary",
            description: "Create professional meeting summaries",
            template: "Please summarize this meeting transcript: [MEETING_CONTENT]. Include key decisions, action items, and next steps. Format it for [AUDIENCE_TYPE].",
            placeholders: ["MEETING_CONTENT", "AUDIENCE_TYPE"],
            category: "Business"
        ),
        Template(
            title: "Email Response",
            description: "Craft professional email responses",
            template: "Write a professional email response to: [EMAIL_CONTENT]. The tone should be [TONE] and include [KEY_POINTS]. Keep it [LENGTH].",
            placeholders: ["EMAIL_CONTENT", "TONE", "KEY_POINTS", "LENGTH"],
            category: "Business"
        ),
        Template(
            title: "Product Description",
            description: "Generate compelling product descriptions",
            template: "Create a compelling product description for [PRODUCT_NAME]. Highlight these key features: [FEATURES]. Target audience: [TARGET_AUDIENCE]. Tone: [TONE].",
            placeholders: ["PRODUCT_NAME", "FEATURES", "TARGET_AUDIENCE", "TONE"],
            category: "Business"
        ),
        
        // Writing Templates
        Template(
            title: "Blog Post Outline",
            description: "Structure engaging blog posts",
            template: "Create a detailed blog post outline for: '[TOPIC]'. Target audience: [AUDIENCE]. Include [NUMBER] main sections, SEO keywords: [KEYWORDS].",
            placeholders: ["TOPIC", "AUDIENCE", "NUMBER", "KEYWORDS"],
            category: "Writing"
        ),
        Template(
            title: "Social Media Post",
            description: "Create engaging social content",
            template: "Write a [PLATFORM] post about [TOPIC]. Include [NUMBER] hashtags, target [AUDIENCE], tone should be [TONE]. Call-to-action: [CTA].",
            placeholders: ["PLATFORM", "TOPIC", "NUMBER", "AUDIENCE", "TONE", "CTA"],
            category: "Writing"
        ),
        
        // Creative Templates
        Template(
            title: "Story Starter",
            description: "Generate creative story beginnings",
            template: "Write the opening paragraph of a [GENRE] story. Main character: [CHARACTER]. Setting: [SETTING]. Conflict: [CONFLICT]. Tone: [TONE].",
            placeholders: ["GENRE", "CHARACTER", "SETTING", "CONFLICT", "TONE"],
            category: "Creative"
        ),
        Template(
            title: "Character Development",
            description: "Build detailed character profiles",
            template: "Create a detailed character profile for [CHARACTER_NAME]. Age: [AGE], occupation: [JOB], personality: [PERSONALITY], background: [BACKGROUND], main goal: [GOAL].",
            placeholders: ["CHARACTER_NAME", "AGE", "JOB", "PERSONALITY", "BACKGROUND", "GOAL"],
            category: "Creative"
        ),
        
        // Technical Templates
        Template(
            title: "Code Review",
            description: "Systematic code review template",
            template: "Review this [LANGUAGE] code for [PURPOSE]: [CODE]. Check for: performance, security, readability, and best practices. Suggest improvements.",
            placeholders: ["LANGUAGE", "PURPOSE", "CODE"],
            category: "Coding"
        ),
        Template(
            title: "Documentation",
            description: "Generate technical documentation",
            template: "Create documentation for [FEATURE/FUNCTION]. Include: purpose, parameters [PARAMETERS], return values [RETURNS], usage examples, and common pitfalls.",
            placeholders: ["FEATURE/FUNCTION", "PARAMETERS", "RETURNS"],
            category: "Coding"
        )
    ]
}