//
//  Prompt.swift
//  PromptPilot
//
//  Created by PromptPilot AI Assistant on 8/4/25.
//

import Foundation

// MARK: - Prompt Model
struct Prompt: Identifiable, Codable {
    let id: UUID
    let title: String
    let content: String
    let category: String
    let tags: [String]
    let recommendedAI: [String] // "ChatGPT", "Claude", "Both"
    var isFavorite: Bool
    
    init(id: UUID = UUID(), title: String, content: String, category: String, tags: [String], recommendedAI: [String], isFavorite: Bool = false) {
        self.id = id
        self.title = title
        self.content = content
        self.category = category
        self.tags = tags
        self.recommendedAI = recommendedAI
        self.isFavorite = isFavorite
    }
}

// MARK: - Sample Data
extension Prompt {
    static let samplePrompts: [Prompt] = [
        // Business (4 prompts)
        Prompt(
            title: "Email Marketing Campaign",
            content: "Create a compelling email marketing campaign for [product/service] targeting [audience]. Include subject line, body copy, and call-to-action.",
            category: "Business",
            tags: ["marketing", "email", "sales", "copywriting"],
            recommendedAI: ["ChatGPT", "Claude"]
        ),
        Prompt(
            title: "Business Plan Executive Summary",
            content: "Write an executive summary for a [business type] startup. Include market opportunity, solution, business model, and financial projections.",
            category: "Business",
            tags: ["strategy", "planning", "startup", "executive"],
            recommendedAI: ["ChatGPT", "Claude"]
        ),
        Prompt(
            title: "Customer Support Response",
            content: "Draft a professional customer support response for [issue type]. Be empathetic, solution-focused, and maintain brand voice.",
            category: "Business",
            tags: ["support", "customer service", "communication"],
            recommendedAI: ["ChatGPT", "Claude"]
        ),
        Prompt(
            title: "Market Research Analysis",
            content: "Analyze the market for [industry/product]. Include market size, trends, competitors, opportunities, and threats.",
            category: "Business",
            tags: ["research", "analysis", "market", "competitive"],
            recommendedAI: ["ChatGPT", "Claude"]
        ),
        
        // Writing (4 prompts)
        Prompt(
            title: "Blog Post Outline",
            content: "Create a detailed outline for a blog post about [topic]. Include engaging headline, introduction, main points, and conclusion.",
            category: "Writing",
            tags: ["blogging", "content", "outline", "SEO"],
            recommendedAI: ["ChatGPT", "Claude"]
        ),
        Prompt(
            title: "Social Media Content",
            content: "Write 5 engaging social media posts about [topic] for [platform]. Include relevant hashtags and call-to-actions.",
            category: "Writing",
            tags: ["social media", "content", "engagement", "hashtags"],
            recommendedAI: ["ChatGPT", "Claude"]
        ),
        Prompt(
            title: "Press Release",
            content: "Write a press release announcing [event/product/news]. Follow standard PR format with compelling headline and quotes.",
            category: "Writing",
            tags: ["PR", "news", "announcement", "media"],
            recommendedAI: ["ChatGPT", "Claude"]
        ),
        Prompt(
            title: "Product Description",
            content: "Write compelling product descriptions for [product]. Highlight benefits, features, and unique selling points.",
            category: "Writing",
            tags: ["product", "e-commerce", "copywriting", "sales"],
            recommendedAI: ["ChatGPT", "Claude"]
        ),
        
        // Coding (4 prompts)
        Prompt(
            title: "Code Review Checklist",
            content: "Create a comprehensive code review checklist for [language/framework]. Include best practices, security, and performance considerations.",
            category: "Coding",
            tags: ["code review", "best practices", "security", "quality"],
            recommendedAI: ["ChatGPT", "Claude"]
        ),
        Prompt(
            title: "API Documentation",
            content: "Write clear API documentation for [endpoint/function]. Include parameters, responses, examples, and error handling.",
            category: "Coding",
            tags: ["documentation", "API", "technical writing"],
            recommendedAI: ["ChatGPT", "Claude"]
        ),
        Prompt(
            title: "Debug Code Issue",
            content: "Help me debug this [language] code: [paste code]. Explain the issue and provide a corrected version with explanation.",
            category: "Coding",
            tags: ["debugging", "troubleshooting", "code analysis"],
            recommendedAI: ["ChatGPT", "Claude"]
        ),
        Prompt(
            title: "Algorithm Explanation",
            content: "Explain the [algorithm name] algorithm in simple terms. Include time complexity, use cases, and implementation example.",
            category: "Coding",
            tags: ["algorithms", "computer science", "education"],
            recommendedAI: ["ChatGPT", "Claude"]
        ),
        
        // More Business Prompts
        Prompt(
            title: "SWOT Analysis",
            content: "Conduct a SWOT analysis for [company/product]. Provide detailed insights on Strengths, Weaknesses, Opportunities, and Threats with actionable recommendations.",
            category: "Business",
            tags: ["analysis", "strategy", "planning", "SWOT"],
            recommendedAI: ["ChatGPT", "Claude", "Gemini"]
        ),
        Prompt(
            title: "Sales Pitch Script",
            content: "Create a compelling sales pitch for [product/service] targeting [customer type]. Include opening hook, value proposition, handling objections, and closing techniques.",
            category: "Business",
            tags: ["sales", "pitch", "script", "persuasion"],
            recommendedAI: ["ChatGPT", "Claude"]
        ),
        Prompt(
            title: "Meeting Agenda Template",
            content: "Create a structured meeting agenda for [meeting type] with [participants]. Include objectives, time allocations, discussion points, and action items.",
            category: "Business",
            tags: ["meetings", "productivity", "planning", "agenda"],
            recommendedAI: ["ChatGPT", "Claude", "Gemini"]
        ),
        Prompt(
            title: "LinkedIn Post Generator",
            content: "Write a professional LinkedIn post about [topic/achievement]. Make it engaging, authentic, and include a call-to-action. Target length: 150-200 words.",
            category: "Business",
            tags: ["LinkedIn", "social media", "professional", "networking"],
            recommendedAI: ["ChatGPT", "Claude"]
        ),
        Prompt(
            title: "Competitive Analysis Report",
            content: "Analyze [number] main competitors of [company/product]. Compare features, pricing, market position, strengths, and weaknesses. Present in a structured format.",
            category: "Business",
            tags: ["competition", "analysis", "market research", "strategy"],
            recommendedAI: ["ChatGPT", "Claude", "Gemini"]
        ),
        
        // More Writing Prompts
        Prompt(
            title: "Newsletter Content",
            content: "Write a newsletter about [topic] for [audience]. Include catchy subject line, 3-4 content sections, and clear CTAs. Keep it under 500 words.",
            category: "Writing",
            tags: ["newsletter", "email", "content", "marketing"],
            recommendedAI: ["ChatGPT", "Claude"]
        ),
        Prompt(
            title: "Case Study Template",
            content: "Write a case study about [project/success story]. Include challenge, solution, implementation, results with metrics, and key takeaways.",
            category: "Writing",
            tags: ["case study", "content", "marketing", "storytelling"],
            recommendedAI: ["ChatGPT", "Claude"]
        ),
        Prompt(
            title: "Video Script Writer",
            content: "Write a script for a [length] video about [topic]. Include hook, main content, visuals suggestions, and call-to-action. Specify tone: [formal/casual/humorous].",
            category: "Writing",
            tags: ["video", "script", "content", "multimedia"],
            recommendedAI: ["ChatGPT", "Claude", "Gemini"]
        ),
        Prompt(
            title: "SEO Meta Descriptions",
            content: "Write SEO-optimized meta descriptions for [webpage/topic]. Maximum 155 characters, include target keyword [keyword], and compelling call-to-action.",
            category: "Writing",
            tags: ["SEO", "meta", "optimization", "web content"],
            recommendedAI: ["ChatGPT", "Claude"]
        ),
        Prompt(
            title: "Podcast Show Notes",
            content: "Create detailed show notes for a podcast episode about [topic]. Include timestamps, key takeaways, guest bio, resources mentioned, and relevant links.",
            category: "Writing",
            tags: ["podcast", "content", "show notes", "media"],
            recommendedAI: ["ChatGPT", "Claude"]
        ),
        
        // More Coding Prompts
        Prompt(
            title: "Unit Test Generator",
            content: "Generate comprehensive unit tests for [function/class] in [language]. Include edge cases, error handling, and both positive and negative test scenarios.",
            category: "Coding",
            tags: ["testing", "unit tests", "quality assurance", "code"],
            recommendedAI: ["ChatGPT", "Claude", "Gemini"]
        ),
        Prompt(
            title: "Code Refactoring Assistant",
            content: "Refactor this [language] code for better readability and performance: [paste code]. Explain each improvement and maintain functionality.",
            category: "Coding",
            tags: ["refactoring", "optimization", "clean code", "best practices"],
            recommendedAI: ["ChatGPT", "Claude"]
        ),
        Prompt(
            title: "Database Query Optimizer",
            content: "Optimize this SQL query for better performance: [paste query]. Explain the optimizations and provide execution plan analysis.",
            category: "Coding",
            tags: ["SQL", "database", "optimization", "performance"],
            recommendedAI: ["ChatGPT", "Claude", "Gemini"]
        ),
        Prompt(
            title: "Error Message Explainer",
            content: "Explain this error message in simple terms: [paste error]. Provide common causes, debugging steps, and solution with code example.",
            category: "Coding",
            tags: ["debugging", "errors", "troubleshooting", "help"],
            recommendedAI: ["ChatGPT", "Claude", "Gemini"]
        ),
        Prompt(
            title: "Design Pattern Implementation",
            content: "Implement the [pattern name] design pattern in [language] for [use case]. Include explanation, benefits, and complete code example.",
            category: "Coding",
            tags: ["design patterns", "architecture", "best practices", "OOP"],
            recommendedAI: ["ChatGPT", "Claude"]
        ),
        
        // Creative (expanded)
        Prompt(
            title: "Story Generator",
            content: "Write a short story about [character] who discovers [object/situation]. Include dialogue, setting, and plot twist.",
            category: "Creative",
            tags: ["storytelling", "fiction", "creative writing"],
            recommendedAI: ["Claude", "ChatGPT"]
        ),
        Prompt(
            title: "Brand Name Ideas",
            content: "Generate 10 creative brand names for a [business type] that conveys [desired feeling/attribute]. Include brief explanations.",
            category: "Creative",
            tags: ["branding", "naming", "creative", "business"],
            recommendedAI: ["ChatGPT", "Claude"]
        ),
        Prompt(
            title: "Creative Writing Prompt",
            content: "Create an imaginative writing prompt involving [theme/setting]. Include character suggestions and potential plot directions.",
            category: "Creative",
            tags: ["writing prompts", "inspiration", "creativity"],
            recommendedAI: ["Claude", "ChatGPT"]
        ),
        Prompt(
            title: "Poetry Generator",
            content: "Write a [style] poem about [subject/theme]. Include specific imagery, emotion, and if specified, follow [rhyme scheme/structure].",
            category: "Creative",
            tags: ["poetry", "creative writing", "artistic", "literature"],
            recommendedAI: ["Claude", "ChatGPT"]
        ),
        Prompt(
            title: "Character Backstory Creator",
            content: "Create a detailed backstory for a [character type] in a [genre] story. Include childhood, motivations, fears, relationships, and defining moments.",
            category: "Creative",
            tags: ["character development", "storytelling", "fiction", "worldbuilding"],
            recommendedAI: ["Claude", "ChatGPT", "Gemini"]
        ),
        Prompt(
            title: "Slogan Generator",
            content: "Create 10 catchy slogans for [brand/product] that emphasizes [key benefit/value]. Keep under 8 words each and make them memorable.",
            category: "Creative",
            tags: ["slogan", "branding", "marketing", "copywriting"],
            recommendedAI: ["ChatGPT", "Claude"]
        ),
        
        // New Category: Education
        Prompt(
            title: "Lesson Plan Creator",
            content: "Create a detailed lesson plan for teaching [topic] to [age group/level]. Include objectives, activities, materials needed, and assessment methods.",
            category: "Education",
            tags: ["teaching", "lesson plan", "education", "curriculum"],
            recommendedAI: ["ChatGPT", "Claude", "Gemini"]
        ),
        Prompt(
            title: "Study Guide Generator",
            content: "Create a comprehensive study guide for [subject/topic]. Include key concepts, definitions, examples, practice questions, and memory aids.",
            category: "Education",
            tags: ["study", "learning", "education", "exam prep"],
            recommendedAI: ["ChatGPT", "Claude"]
        ),
        Prompt(
            title: "Complex Concept Simplifier",
            content: "Explain [complex topic] in simple terms that a [age/knowledge level] can understand. Use analogies and real-world examples.",
            category: "Education",
            tags: ["explanation", "teaching", "simplification", "learning"],
            recommendedAI: ["ChatGPT", "Claude", "Gemini"]
        ),
        Prompt(
            title: "Quiz Question Creator",
            content: "Create [number] quiz questions about [topic] at [difficulty level]. Include multiple choice, true/false, and short answer with answer key.",
            category: "Education",
            tags: ["quiz", "assessment", "questions", "testing"],
            recommendedAI: ["ChatGPT", "Claude"]
        ),
        
        // New Category: Personal
        Prompt(
            title: "Resume Bullet Points",
            content: "Transform this job responsibility into 3 impressive resume bullet points: [responsibility]. Use action verbs and quantify results where possible.",
            category: "Personal",
            tags: ["resume", "career", "job search", "professional"],
            recommendedAI: ["ChatGPT", "Claude"]
        ),
        Prompt(
            title: "Cover Letter Template",
            content: "Write a cover letter for [position] at [company type]. Highlight [key skills/experiences] and show enthusiasm for [company aspect].",
            category: "Personal",
            tags: ["cover letter", "job application", "career", "writing"],
            recommendedAI: ["ChatGPT", "Claude"]
        ),
        Prompt(
            title: "Daily Journal Prompts",
            content: "Generate 7 thought-provoking journal prompts for [theme/focus area]. Include mix of reflection, gratitude, and goal-setting questions.",
            category: "Personal",
            tags: ["journaling", "self-reflection", "personal growth", "mindfulness"],
            recommendedAI: ["Claude", "ChatGPT"]
        ),
        Prompt(
            title: "Personal Goal Planner",
            content: "Help me create a SMART goal plan for [objective]. Break it down into weekly milestones, potential obstacles, and success metrics.",
            category: "Personal",
            tags: ["goals", "planning", "personal development", "productivity"],
            recommendedAI: ["ChatGPT", "Claude", "Gemini"]
        )
    ]
}