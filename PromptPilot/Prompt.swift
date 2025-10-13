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
        ),
        
        // New Category: Google Nano Banana
        // Photorealistic Scenes
        Prompt(
            title: "Macro Dewdrop Photography",
            content: "A macro photograph of a single dewdrop on a blade of grass, reflecting the sunrise. The background is a soft, out-of-focus green field. The lighting is warm and golden.",
            category: "Google Nano Banana",
            tags: ["photorealistic", "macro", "nature", "sunrise"],
            recommendedAI: ["Gemini"]
        ),
        Prompt(
            title: "Aerial Forest in Fog",
            content: "An aerial, top-down shot of a dense, foggy pine forest in the Pacific Northwest. The tips of the tallest trees are just visible through the thick layer of fog.",
            category: "Google Nano Banana",
            tags: ["photorealistic", "aerial", "forest", "fog"],
            recommendedAI: ["Gemini"]
        ),
        Prompt(
            title: "Street Musician at Dusk",
            content: "A candid, street-style photograph of a musician playing a saxophone on a Parisian street corner at dusk. The city lights are beginning to twinkle in the background, creating a beautiful bokeh effect. Shot on a 50mm lens.",
            category: "Google Nano Banana",
            tags: ["photorealistic", "street photography", "music", "paris"],
            recommendedAI: ["Gemini"]
        ),
        Prompt(
            title: "Cozy Cabin Library",
            content: "An interior shot of a rustic, cozy cabin library with a stone fireplace crackling. A leather armchair sits next to the fire, and floor-to-ceiling bookshelves are filled with old books. The only light source is the fire and a small, warm lamp.",
            category: "Google Nano Banana",
            tags: ["photorealistic", "interior", "cozy", "library"],
            recommendedAI: ["Gemini"]
        ),
        Prompt(
            title: "Icelandic Beach Scene",
            content: "A photorealistic close-up of an old, weathered wooden boat pulled up on a black sand beach in Iceland. The sky is overcast and dramatic, and volcanic mountains are visible in the distance.",
            category: "Google Nano Banana",
            tags: ["photorealistic", "iceland", "beach", "dramatic"],
            recommendedAI: ["Gemini"]
        ),
        
        // Image Editing and Manipulation
        Prompt(
            title: "Add Glasses to Portrait",
            content: "Using the provided photo, add a pair of modern, black-rimmed glasses to the man's face.",
            category: "Google Nano Banana",
            tags: ["image editing", "portrait", "glasses", "face"],
            recommendedAI: ["Gemini"]
        ),
        Prompt(
            title: "Japanese Garden Background",
            content: "Change the background of this portrait to a serene Japanese garden with a koi pond and cherry blossom trees.",
            category: "Google Nano Banana",
            tags: ["image editing", "background", "japanese garden", "portrait"],
            recommendedAI: ["Gemini"]
        ),
        Prompt(
            title: "Remove Background People",
            content: "Remove the tourists in the background of this photo, leaving only the main subject in front of the monument.",
            category: "Google Nano Banana",
            tags: ["image editing", "remove objects", "cleanup", "monument"],
            recommendedAI: ["Gemini"]
        ),
        Prompt(
            title: "Dramatic Sky Replacement",
            content: "Replace the daytime sky in this landscape photo with a dramatic, stormy sky with dark clouds.",
            category: "Google Nano Banana",
            tags: ["image editing", "sky replacement", "dramatic", "landscape"],
            recommendedAI: ["Gemini"]
        ),
        Prompt(
            title: "Change Dress Color",
            content: "Change the woman's blue dress to a vibrant emerald green.",
            category: "Google Nano Banana",
            tags: ["image editing", "color change", "fashion", "portrait"],
            recommendedAI: ["Gemini"]
        ),
        Prompt(
            title: "Add Coffee Mug",
            content: "Add a steaming ceramic mug of coffee on the wooden table in the foreground.",
            category: "Google Nano Banana",
            tags: ["image editing", "add object", "coffee", "table"],
            recommendedAI: ["Gemini"]
        ),
        
        // Artistic Styles and Graphics
        Prompt(
            title: "Quantum Bean Coffee Logo",
            content: "A logo for a coffee shop named 'The Quantum Bean,' featuring a stylized atom with a coffee bean as the nucleus. The style should be modern, minimalist, and use a black and white color scheme.",
            category: "Google Nano Banana",
            tags: ["logo design", "minimalist", "coffee", "modern"],
            recommendedAI: ["Gemini"]
        ),
        Prompt(
            title: "Van Gogh Style Cat Portrait",
            content: "A portrait of a cat in the style of a Van Gogh painting, with thick, swirling brushstrokes and a vibrant, expressive color palette.",
            category: "Google Nano Banana",
            tags: ["artistic style", "van gogh", "cat", "painting"],
            recommendedAI: ["Gemini"]
        ),
        Prompt(
            title: "Ukiyo-e Futuristic City",
            content: "A Ukiyo-e woodblock print style illustration of a futuristic city skyline with flying vehicles and holographic advertisements.",
            category: "Google Nano Banana",
            tags: ["ukiyo-e", "japanese art", "futuristic", "city"],
            recommendedAI: ["Gemini"]
        ),
        Prompt(
            title: "Noir Detective Comic Panel",
            content: "A single comic book panel in a gritty, noir art style with high-contrast black and white inks. A detective in a trench coat stands under a single streetlamp on a rainy night. Caption box at the top reads: 'The city never sleeps, and neither did its ghosts.'",
            category: "Google Nano Banana",
            tags: ["comic art", "noir", "detective", "black and white"],
            recommendedAI: ["Gemini"]
        ),
        Prompt(
            title: "Retro Mars Travel Poster",
            content: "A vector art travel poster for Mars. The design should be minimalist with a retro-futuristic aesthetic, featuring the Olympus Mons volcano and two small astronauts. Use a limited color palette of red, orange, and cream.",
            category: "Google Nano Banana",
            tags: ["vector art", "travel poster", "mars", "retro-futuristic"],
            recommendedAI: ["Gemini"]
        ),
        
        // Creative and Imaginative Concepts
        Prompt(
            title: "Melting Clock Floating Island",
            content: "A surrealist scene of a giant, antique pocket watch melting over the edge of a floating island in the sky. Flocks of birds made of paper are flying around it.",
            category: "Google Nano Banana",
            tags: ["surreal", "floating island", "melting clock", "fantasy"],
            recommendedAI: ["Gemini"]
        ),
        Prompt(
            title: "Bioluminescent Forest",
            content: "A bioluminescent forest at night, where the trees, mushrooms, and flowers glow with ethereal blue and green light. A crystal-clear river flows through the scene, reflecting the glowing flora.",
            category: "Google Nano Banana",
            tags: ["bioluminescent", "fantasy", "glowing", "forest"],
            recommendedAI: ["Gemini"]
        ),
        Prompt(
            title: "Astronaut with Celestial Map",
            content: "An astronaut peacefully floating in space, with the Earth reflected in their helmet visor, but instead of continents, the reflection shows a detailed, antique celestial map.",
            category: "Google Nano Banana",
            tags: ["space", "astronaut", "celestial", "surreal"],
            recommendedAI: ["Gemini"]
        ),
        Prompt(
            title: "Book Building City",
            content: "A bustling city street where all the buildings are made of intricately carved books, and the streetlights are glowing bookmarks.",
            category: "Google Nano Banana",
            tags: ["fantasy", "books", "city", "imaginative"],
            recommendedAI: ["Gemini"]
        ),
        Prompt(
            title: "Crystal Glass Elephant",
            content: "An elephant made entirely of crystalline glass, walking through a desert of shimmering black sand under a sky with two moons.",
            category: "Google Nano Banana",
            tags: ["crystal", "elephant", "desert", "fantasy"],
            recommendedAI: ["Gemini"]
        ),
        
        // More Business Prompts
        Prompt(
            title: "Project Proposal Writer",
            content: "Write a comprehensive project proposal for [project name]. Include executive summary, objectives, methodology, timeline, budget breakdown, team requirements, and expected deliverables.",
            category: "Business",
            tags: ["project management", "proposal", "planning", "business"],
            recommendedAI: ["ChatGPT", "Claude"]
        ),
        Prompt(
            title: "Employee Performance Review",
            content: "Draft a performance review for [employee name] in [role]. Include strengths, areas for improvement, specific examples, goals for next period, and development recommendations.",
            category: "Business",
            tags: ["HR", "performance", "feedback", "management"],
            recommendedAI: ["ChatGPT", "Claude"]
        ),
        Prompt(
            title: "Crisis Communication Plan",
            content: "Create a crisis communication plan for [crisis type] at [company type]. Include key messages, stakeholder communication, timeline, and damage control strategies.",
            category: "Business",
            tags: ["crisis", "communication", "PR", "management"],
            recommendedAI: ["ChatGPT", "Claude", "Gemini"]
        ),
        Prompt(
            title: "Vendor Evaluation Matrix",
            content: "Create a vendor evaluation framework for [service/product type]. Include criteria, scoring system, cost analysis, and decision matrix for [number] vendors.",
            category: "Business",
            tags: ["procurement", "evaluation", "vendors", "decision making"],
            recommendedAI: ["ChatGPT", "Claude"]
        ),
        Prompt(
            title: "Board Meeting Presentation",
            content: "Create a board presentation outline for [topic]. Include executive summary, key metrics, challenges, opportunities, recommendations, and next steps. Keep it concise and data-driven.",
            category: "Business",
            tags: ["board meeting", "presentation", "executive", "strategy"],
            recommendedAI: ["ChatGPT", "Claude"]
        ),
        
        // More Writing Prompts
        Prompt(
            title: "Grant Proposal Writer",
            content: "Write a grant proposal for [project/organization] seeking [amount] for [purpose]. Include problem statement, solution, methodology, budget, and impact measurement.",
            category: "Writing",
            tags: ["grants", "funding", "non-profit", "proposals"],
            recommendedAI: ["ChatGPT", "Claude"]
        ),
        Prompt(
            title: "White Paper Outline",
            content: "Create a white paper outline on [topic] for [industry]. Include executive summary, problem analysis, solution overview, implementation guide, and conclusion.",
            category: "Writing",
            tags: ["white paper", "thought leadership", "B2B", "content"],
            recommendedAI: ["ChatGPT", "Claude"]
        ),
        Prompt(
            title: "Email Sequence Creator",
            content: "Design a [number]-email welcome sequence for [business type]. Include subject lines, content themes, timing, and clear CTAs for each email.",
            category: "Writing",
            tags: ["email marketing", "sequence", "automation", "nurture"],
            recommendedAI: ["ChatGPT", "Claude"]
        ),
        Prompt(
            title: "Technical Documentation",
            content: "Write user documentation for [software/feature]. Include getting started guide, feature explanations, troubleshooting section, and FAQ.",
            category: "Writing",
            tags: ["technical writing", "documentation", "user guide", "software"],
            recommendedAI: ["ChatGPT", "Claude", "Gemini"]
        ),
        Prompt(
            title: "Content Repurposing Plan",
            content: "Transform this [content type] into 10 different formats: [original content]. Include social posts, infographics, videos, podcasts, and blog derivatives.",
            category: "Writing",
            tags: ["content repurposing", "content strategy", "multi-format", "efficiency"],
            recommendedAI: ["ChatGPT", "Claude"]
        ),
        
        // More Coding Prompts
        Prompt(
            title: "Architecture Decision Record",
            content: "Write an ADR for choosing [technology/approach] over alternatives. Include context, decision, consequences, and trade-offs for [project/system].",
            category: "Coding",
            tags: ["architecture", "documentation", "decision making", "technical"],
            recommendedAI: ["ChatGPT", "Claude"]
        ),
        Prompt(
            title: "Security Code Review",
            content: "Perform a security-focused code review of [language/framework] code: [paste code]. Check for vulnerabilities, authentication issues, and security best practices.",
            category: "Coding",
            tags: ["security", "code review", "vulnerabilities", "cybersecurity"],
            recommendedAI: ["ChatGPT", "Claude", "Gemini"]
        ),
        Prompt(
            title: "Performance Profiling Guide",
            content: "Create a performance profiling strategy for [application type] in [language]. Include tools, metrics to track, bottleneck identification, and optimization techniques.",
            category: "Coding",
            tags: ["performance", "profiling", "optimization", "monitoring"],
            recommendedAI: ["ChatGPT", "Claude"]
        ),
        Prompt(
            title: "CI/CD Pipeline Design",
            content: "Design a CI/CD pipeline for [project type] using [tools/platforms]. Include build stages, testing phases, deployment strategies, and rollback procedures.",
            category: "Coding",
            tags: ["CI/CD", "DevOps", "automation", "deployment"],
            recommendedAI: ["ChatGPT", "Claude", "Gemini"]
        ),
        Prompt(
            title: "Code Migration Strategy",
            content: "Plan a migration from [old technology] to [new technology] for [system type]. Include timeline, risk assessment, rollback plan, and testing strategy.",
            category: "Coding",
            tags: ["migration", "legacy systems", "modernization", "planning"],
            recommendedAI: ["ChatGPT", "Claude"]
        ),
        
        // More Creative Prompts
        Prompt(
            title: "Worldbuilding Generator",
            content: "Create a detailed fictional world for [genre]. Include geography, cultures, political systems, magic/technology rules, history, and current conflicts.",
            category: "Creative",
            tags: ["worldbuilding", "fiction", "fantasy", "sci-fi"],
            recommendedAI: ["Claude", "ChatGPT", "Gemini"]
        ),
        Prompt(
            title: "Dialogue Scene Creator",
            content: "Write a dialogue-heavy scene between [character 1] and [character 2] about [conflict/topic]. Show personality through speech patterns and subtext.",
            category: "Creative",
            tags: ["dialogue", "character development", "scene writing", "fiction"],
            recommendedAI: ["Claude", "ChatGPT"]
        ),
        Prompt(
            title: "Song Lyrics Generator",
            content: "Write lyrics for a [genre] song about [theme/story]. Include verse-chorus structure, rhyme scheme, and emotional progression. Target length: [duration].",
            category: "Creative",
            tags: ["songwriting", "lyrics", "music", "poetry"],
            recommendedAI: ["Claude", "ChatGPT"]
        ),
        Prompt(
            title: "Creative Campaign Ideas",
            content: "Generate 10 creative campaign concepts for [brand/product] targeting [audience]. Include unique angles, emotional hooks, and execution ideas.",
            category: "Creative",
            tags: ["advertising", "campaigns", "creative concepts", "marketing"],
            recommendedAI: ["ChatGPT", "Claude", "Gemini"]
        ),
        Prompt(
            title: "Plot Twist Generator",
            content: "Create 5 unexpected plot twists for a [genre] story about [basic premise]. Include setup requirements and impact on character development.",
            category: "Creative",
            tags: ["plot twists", "storytelling", "narrative", "fiction"],
            recommendedAI: ["Claude", "ChatGPT"]
        ),
        
        // More Education Prompts
        Prompt(
            title: "Curriculum Designer",
            content: "Design a [duration] curriculum for [subject] at [level]. Include learning objectives, module breakdown, assessments, and resource requirements.",
            category: "Education",
            tags: ["curriculum", "course design", "education", "learning"],
            recommendedAI: ["ChatGPT", "Claude", "Gemini"]
        ),
        Prompt(
            title: "Interactive Learning Activity",
            content: "Create an engaging learning activity for [topic] suitable for [age/level]. Include materials, step-by-step instructions, and learning outcomes.",
            category: "Education",
            tags: ["interactive learning", "activities", "engagement", "pedagogy"],
            recommendedAI: ["ChatGPT", "Claude"]
        ),
        Prompt(
            title: "Research Paper Outline",
            content: "Create a research paper outline on [topic]. Include thesis statement, main arguments, supporting evidence structure, and citation requirements.",
            category: "Education",
            tags: ["research", "academic writing", "thesis", "outline"],
            recommendedAI: ["ChatGPT", "Claude"]
        ),
        Prompt(
            title: "Learning Assessment Rubric",
            content: "Design a rubric for assessing [skill/subject] at [level]. Include criteria, performance levels, descriptors, and scoring guidelines.",
            category: "Education",
            tags: ["assessment", "rubric", "evaluation", "grading"],
            recommendedAI: ["ChatGPT", "Claude"]
        ),
        
        // More Personal Prompts
        Prompt(
            title: "Interview Preparation Coach",
            content: "Help me prepare for a [job title] interview at [company type]. Generate likely questions, suggested answers, and tips for [specific challenge].",
            category: "Personal",
            tags: ["interview", "job search", "career", "preparation"],
            recommendedAI: ["ChatGPT", "Claude"]
        ),
        Prompt(
            title: "Personal Brand Statement",
            content: "Create a personal brand statement for [profession/industry]. Highlight [key strengths], target [audience], and convey [desired perception]. Keep it under 50 words.",
            category: "Personal",
            tags: ["personal branding", "career", "professional", "identity"],
            recommendedAI: ["ChatGPT", "Claude"]
        ),
        Prompt(
            title: "Habit Formation Plan",
            content: "Design a plan to build the habit of [habit] over [timeframe]. Include triggers, rewards, tracking methods, and obstacle management strategies.",
            category: "Personal",
            tags: ["habits", "behavior change", "personal development", "goals"],
            recommendedAI: ["ChatGPT", "Claude", "Gemini"]
        ),
        Prompt(
            title: "Budget Planning Assistant",
            content: "Create a monthly budget plan for [income level] with priorities: [priorities]. Include categories, percentages, saving goals, and expense tracking methods.",
            category: "Personal",
            tags: ["budgeting", "finance", "money management", "planning"],
            recommendedAI: ["ChatGPT", "Claude"]
        ),
        Prompt(
            title: "Travel Planning Guide",
            content: "Plan a [duration] trip to [destination] for [number] people with budget [amount]. Include itinerary, accommodations, transportation, and must-see attractions.",
            category: "Personal",
            tags: ["travel", "planning", "vacation", "itinerary"],
            recommendedAI: ["ChatGPT", "Claude", "Gemini"]
        ),
        
        // New Category: Marketing
        Prompt(
            title: "Customer Journey Mapping",
            content: "Map the customer journey for [product/service] from awareness to advocacy. Include touchpoints, emotions, pain points, and optimization opportunities.",
            category: "Marketing",
            tags: ["customer journey", "UX", "marketing strategy", "optimization"],
            recommendedAI: ["ChatGPT", "Claude", "Gemini"]
        ),
        Prompt(
            title: "Social Media Strategy",
            content: "Create a 3-month social media strategy for [brand] on [platforms]. Include content themes, posting schedule, engagement tactics, and KPIs.",
            category: "Marketing",
            tags: ["social media", "strategy", "content planning", "engagement"],
            recommendedAI: ["ChatGPT", "Claude"]
        ),
        Prompt(
            title: "Influencer Outreach Template",
            content: "Write an influencer outreach email for [brand/campaign]. Include personalization, value proposition, collaboration details, and clear next steps.",
            category: "Marketing",
            tags: ["influencer marketing", "outreach", "collaboration", "partnerships"],
            recommendedAI: ["ChatGPT", "Claude"]
        ),
        Prompt(
            title: "A/B Test Hypothesis",
            content: "Create A/B test hypotheses for [element] on [page/campaign]. Include test variations, success metrics, and expected outcomes for [goal].",
            category: "Marketing",
            tags: ["A/B testing", "conversion optimization", "experimentation", "data"],
            recommendedAI: ["ChatGPT", "Claude"]
        ),
        Prompt(
            title: "Brand Positioning Statement",
            content: "Develop a brand positioning statement for [brand] in [market]. Include target audience, competitive differentiation, and unique value proposition.",
            category: "Marketing",
            tags: ["brand positioning", "strategy", "differentiation", "messaging"],
            recommendedAI: ["ChatGPT", "Claude"]
        ),
        
        // New Category: Health & Wellness
        Prompt(
            title: "Workout Plan Creator",
            content: "Design a [duration] workout plan for [fitness goal] at [fitness level]. Include exercises, sets/reps, progression, and recovery recommendations.",
            category: "Health",
            tags: ["fitness", "workout", "exercise", "health"],
            recommendedAI: ["ChatGPT", "Claude", "Gemini"]
        ),
        Prompt(
            title: "Meal Planning Assistant",
            content: "Create a weekly meal plan for [dietary preference] with [calorie target]. Include breakfast, lunch, dinner, snacks, and shopping list.",
            category: "Health",
            tags: ["nutrition", "meal planning", "diet", "healthy eating"],
            recommendedAI: ["ChatGPT", "Claude"]
        ),
        Prompt(
            title: "Mindfulness Practice Guide",
            content: "Design a [duration] mindfulness practice for [specific need/goal]. Include guided steps, breathing techniques, and progress tracking methods.",
            category: "Health",
            tags: ["mindfulness", "meditation", "mental health", "wellness"],
            recommendedAI: ["Claude", "ChatGPT"]
        ),
        Prompt(
            title: "Sleep Optimization Plan",
            content: "Create a sleep improvement plan addressing [sleep issues]. Include sleep hygiene tips, bedtime routine, environment optimization, and tracking methods.",
            category: "Health",
            tags: ["sleep", "wellness", "health optimization", "habits"],
            recommendedAI: ["ChatGPT", "Claude"]
        ),
        
        // New Category: Finance
        Prompt(
            title: "Investment Strategy Guide",
            content: "Explain investment strategies for [investor profile] with [time horizon] and [risk tolerance]. Include asset allocation, diversification, and rebalancing tips.",
            category: "Finance",
            tags: ["investing", "portfolio", "financial planning", "wealth"],
            recommendedAI: ["ChatGPT", "Claude"]
        ),
        Prompt(
            title: "Debt Payoff Strategy",
            content: "Create a debt payoff plan for [debt amount] across [number] accounts. Compare avalanche vs snowball methods and provide timeline with [monthly payment].",
            category: "Finance",
            tags: ["debt management", "financial planning", "budgeting", "payoff"],
            recommendedAI: ["ChatGPT", "Claude"]
        ),
        Prompt(
            title: "Tax Optimization Tips",
            content: "Provide tax optimization strategies for [taxpayer type] earning [income range]. Include deductions, credits, and year-end planning recommendations.",
            category: "Finance",
            tags: ["taxes", "optimization", "deductions", "financial planning"],
            recommendedAI: ["ChatGPT", "Claude"]
        ),
        Prompt(
            title: "Retirement Planning Calculator",
            content: "Calculate retirement needs for [current age] planning to retire at [retirement age] with [lifestyle goals]. Include savings rate, investment growth, and inflation adjustments.",
            category: "Finance",
            tags: ["retirement", "planning", "savings", "financial goals"],
            recommendedAI: ["ChatGPT", "Claude"]
        ),
        
        // New Category: Sora 2 (AI Video Generation)
        Prompt(
            title: "Fantasy Forest Dawn Scene",
            content: "A fantasy forest at dawn, glowing with magical lights; a curious fox exploring; 35mm lens, moody and vibrant colors, cinematic style.",
            category: "Sora 2",
            tags: ["video generation", "fantasy", "nature", "cinematic", "magical"],
            recommendedAI: ["Sora 2"]
        ),
        Prompt(
            title: "Tokyo Neon Alley Night",
            content: "A rainy neon alley in Tokyo at night; medium close-up on a courier adjusting his helmet; handheld camera pushing in slowly; wet asphalt glistening; moody, synthwave palette.",
            category: "Sora 2",
            tags: ["video generation", "cyberpunk", "urban", "night", "cinematic"],
            recommendedAI: ["Sora 2"]
        ),
        Prompt(
            title: "Forest Clearing Crane Shot",
            content: "Establishing shot of a sunlit forest clearing; 24mm wide angle, slow crane down through drifting pollen, resolving into a medium shot of a hiker tying boots.",
            category: "Sora 2",
            tags: ["video generation", "nature", "cinematic", "outdoor", "movement"],
            recommendedAI: ["Sora 2"]
        ),
        Prompt(
            title: "Urban Skateboard Kickflip",
            content: "A skateboarder performing a kickflip on a sunny urban street; detailed street textures with realistic shadows; synchronized sound of wheels and city ambiance.",
            category: "Sora 2",
            tags: ["video generation", "sports", "urban", "action", "street"],
            recommendedAI: ["Sora 2"]
        ),
        Prompt(
            title: "Animated Pikachu with Audio",
            content: "A cartoon Pikachu playing with a microphone; bright colors, lively motions, synchronized audio with character dialogue and ASMR effects.",
            category: "Sora 2",
            tags: ["video generation", "animation", "character", "audio", "cartoon"],
            recommendedAI: ["Sora 2"]
        ),
        Prompt(
            title: "Cinematic Dolly Shot Template",
            content: "Create a [scene type] using a dolly shot technique; [subject] in [environment]; [camera movement] with [lighting style]; emphasize [mood/emotion] through [visual elements].",
            category: "Sora 2",
            tags: ["video generation", "cinematic", "camera movement", "template", "directing"],
            recommendedAI: ["Sora 2"]
        ),
        Prompt(
            title: "Close-up Character Study",
            content: "Medium close-up of [character type] [action/emotion] in [setting]; [lens type], [lighting description]; capture [specific detail] with [camera technique]; [color palette] mood.",
            category: "Sora 2",
            tags: ["video generation", "portrait", "character", "emotion", "cinematic"],
            recommendedAI: ["Sora 2"]
        ),
        Prompt(
            title: "Dynamic Action Sequence",
            content: "[Action description] in [environment]; [camera angle] following [subject]; [motion type] with [speed/rhythm]; realistic [physics/textures]; [audio elements] synchronized.",
            category: "Sora 2",
            tags: ["video generation", "action", "movement", "dynamic", "realistic"],
            recommendedAI: ["Sora 2"]
        )
    ]
}