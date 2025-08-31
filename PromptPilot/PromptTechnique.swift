//
//  PromptTechnique.swift
//  PromptPilot
//
//  Created by PromptPilot AI Assistant on 8/4/25.
//

import Foundation

// MARK: - Prompt Technique Model
struct PromptTechnique: Identifiable, Codable {
    let id = UUID()
    let name: String
    let level: String // "Beginner", "Intermediate", "Advanced"
    let description: String
    let explanation: String
    let example: String
    let expectedOutput: String
    let tips: [String]
    let category: String
}

// MARK: - Daily Challenge Model
struct DailyChallenge: Identifiable, Codable {
    let id = UUID()
    let date: Date
    let title: String
    let description: String
    let difficulty: String
    let prompt: String
    let hints: [String]
    let sampleSolution: String
}

// MARK: - Sample Techniques
extension PromptTechnique {
    static let sampleTechniques: [PromptTechnique] = [
        // Beginner Techniques
        PromptTechnique(
            name: "Clear Instructions",
            level: "Beginner",
            description: "Be specific and direct about what you want",
            explanation: "The foundation of good prompting is clarity. Tell the AI exactly what you need, including format, length, and style.",
            example: "Write a 3-paragraph summary of climate change for a 10-year-old. Use simple language and include one fun fact in each paragraph.",
            expectedOutput: "Climate change is when Earth gets warmer because of things people do...[continues with age-appropriate explanation]",
            tips: [
                "Specify the format (paragraphs, bullets, etc.)",
                "Define your audience",
                "Set clear length requirements",
                "Use simple, direct language"
            ],
            category: "Fundamentals"
        ),
        PromptTechnique(
            name: "Role Assignment",
            level: "Beginner",
            description: "Ask the AI to act as a specific expert or character",
            explanation: "Giving the AI a role helps it adopt the right tone, expertise level, and perspective for your needs.",
            example: "Act as a professional chef. Explain how to make the perfect scrambled eggs, including pro tips that home cooks usually miss.",
            expectedOutput: "As a professional chef with 20 years of experience, let me share the secrets to perfect scrambled eggs...",
            tips: [
                "Be specific about the role's expertise",
                "Include relevant background if needed",
                "Mention the role's perspective or approach",
                "Consider the role's typical communication style"
            ],
            category: "Fundamentals"
        ),
        PromptTechnique(
            name: "Example-Driven Prompting",
            level: "Beginner",
            description: "Provide examples of what you want",
            explanation: "Showing the AI examples of desired output helps it understand your expectations better than description alone.",
            example: "Convert these sentences to active voice. Example: 'The ball was thrown by John' → 'John threw the ball'. Now convert: 'The cake was eaten by the children'",
            expectedOutput: "The children ate the cake",
            tips: [
                "Provide 1-3 clear examples",
                "Show the transformation you want",
                "Use consistent formatting",
                "Include edge cases if relevant"
            ],
            category: "Fundamentals"
        ),
        
        // Intermediate Techniques
        PromptTechnique(
            name: "Chain of Thought",
            level: "Intermediate",
            description: "Ask the AI to explain its reasoning step-by-step",
            explanation: "Breaking down complex problems into steps improves accuracy and helps you understand the AI's logic.",
            example: "Solve this step-by-step: If a shirt costs $40 and is on sale for 25% off, plus you have a $5 coupon, what's the final price? Show your work.",
            expectedOutput: "Step 1: Calculate 25% discount: $40 × 0.25 = $10\nStep 2: Apply discount: $40 - $10 = $30\nStep 3: Apply coupon: $30 - $5 = $25\nFinal price: $25",
            tips: [
                "Use phrases like 'think step-by-step'",
                "Ask to 'show your work'",
                "Request numbered steps",
                "Useful for math, logic, and analysis"
            ],
            category: "Reasoning"
        ),
        PromptTechnique(
            name: "Few-Shot Learning",
            level: "Intermediate",
            description: "Provide multiple examples to establish a pattern",
            explanation: "Give the AI several examples of input-output pairs so it can learn the pattern and apply it to new cases.",
            example: "Classify sentiment:\n'I love this!' → Positive\n'This is terrible' → Negative\n'It's okay, I guess' → Neutral\n'Best purchase ever!' → ?",
            expectedOutput: "Positive",
            tips: [
                "Provide 3-5 examples minimum",
                "Cover different cases",
                "Keep examples consistent",
                "Test with edge cases"
            ],
            category: "Patterns"
        ),
        PromptTechnique(
            name: "Structured Output",
            level: "Intermediate",
            description: "Request specific formatting like JSON, tables, or templates",
            explanation: "Defining the exact structure you want ensures consistent, parseable output that's easy to use.",
            example: "Analyze this product review and return a JSON object with keys: 'sentiment' (positive/negative/neutral), 'rating' (1-5), 'key_points' (array of strings). Review: 'Great product but shipping was slow.'",
            expectedOutput: "{\n  \"sentiment\": \"positive\",\n  \"rating\": 4,\n  \"key_points\": [\"High product quality\", \"Slow shipping\"]\n}",
            tips: [
                "Specify exact format needed",
                "Define all fields clearly",
                "Give example of expected structure",
                "Mention data types if relevant"
            ],
            category: "Formatting"
        ),
        
        // Advanced Techniques
        PromptTechnique(
            name: "Meta-Prompting",
            level: "Advanced",
            description: "Ask the AI to improve or create its own prompts",
            explanation: "Have the AI help you craft better prompts by analyzing and improving your initial attempts.",
            example: "Here's my prompt: 'Write about dogs.' How would you improve this prompt to get a more specific, useful response? Then execute the improved version.",
            expectedOutput: "Improved prompt: 'Write a 300-word informative article about the top 3 family-friendly dog breeds, including temperament, size, and care requirements for each.'",
            tips: [
                "Ask AI to critique your prompts",
                "Request prompt improvements",
                "Have AI generate prompts for tasks",
                "Iterate on prompt quality"
            ],
            category: "Meta"
        ),
        PromptTechnique(
            name: "Constrained Generation",
            level: "Advanced",
            description: "Set specific constraints and boundaries for output",
            explanation: "Adding constraints forces creative solutions and ensures output meets exact requirements.",
            example: "Write a story about time travel in exactly 50 words. Must include the words 'paradox', 'butterfly', and 'yesterday'. Must end with a question.",
            expectedOutput: "Yesterday, Dr. Chen discovered the butterfly effect wasn't just theory. One small change created a paradox that rippled through time...[exactly 50 words ending with question]",
            tips: [
                "Set word/character limits",
                "Require specific elements",
                "Define what to exclude",
                "Combine multiple constraints"
            ],
            category: "Creative"
        ),
        PromptTechnique(
            name: "Self-Consistency Check",
            level: "Advanced",
            description: "Ask the AI to verify and critique its own output",
            explanation: "Having the AI review its own work can catch errors and improve quality through self-reflection.",
            example: "Solve this problem, then check your answer for errors: Calculate the compound interest on $1000 at 5% annual rate for 3 years. After solving, verify your calculation and identify any potential mistakes.",
            expectedOutput: "Calculation: $1000 × (1.05)³ = $1,157.63\nVerification: Year 1: $1,050, Year 2: $1,102.50, Year 3: $1,157.63 ✓\nNo errors found. The calculation is correct.",
            tips: [
                "Ask for verification steps",
                "Request error checking",
                "Have AI critique its logic",
                "Use for important tasks"
            ],
            category: "Validation"
        )
    ]
}