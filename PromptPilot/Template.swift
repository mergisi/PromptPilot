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
        ),
        
        // More Business Templates
        Template(
            title: "Sales Pitch",
            description: "Create compelling sales presentations",
            template: "Create a sales pitch for [PRODUCT/SERVICE] targeting [TARGET_CUSTOMER]. Problem: [PROBLEM], Solution: [SOLUTION], Benefits: [BENEFITS], Price: [PRICE]. Duration: [DURATION] minutes.",
            placeholders: ["PRODUCT/SERVICE", "TARGET_CUSTOMER", "PROBLEM", "SOLUTION", "BENEFITS", "PRICE", "DURATION"],
            category: "Business"
        ),
        Template(
            title: "Job Interview Questions",
            description: "Generate interview questions for candidates",
            template: "Create [NUMBER] interview questions for a [JOB_TITLE] position. Company: [COMPANY], Required skills: [SKILLS], Experience level: [LEVEL]. Include behavioral and technical questions.",
            placeholders: ["NUMBER", "JOB_TITLE", "COMPANY", "SKILLS", "LEVEL"],
            category: "Business"
        ),
        Template(
            title: "Market Research Analysis",
            description: "Analyze market research data",
            template: "Analyze this market research data for [PRODUCT/MARKET]: [DATA]. Identify trends, opportunities, threats, and provide [NUMBER] actionable recommendations for [TARGET_AUDIENCE].",
            placeholders: ["PRODUCT/MARKET", "DATA", "NUMBER", "TARGET_AUDIENCE"],
            category: "Business"
        ),
        Template(
            title: "Business Plan Section",
            description: "Write specific business plan sections",
            template: "Write the [SECTION] section of a business plan for [BUSINESS_NAME]. Industry: [INDUSTRY], Target market: [MARKET], Key differentiator: [DIFFERENTIATOR]. Make it [LENGTH] and [TONE].",
            placeholders: ["SECTION", "BUSINESS_NAME", "INDUSTRY", "MARKET", "DIFFERENTIATOR", "LENGTH", "TONE"],
            category: "Business"
        ),
        
        // More Writing Templates
        Template(
            title: "Press Release",
            description: "Write professional press releases",
            template: "Write a press release for [COMPANY] announcing [NEWS]. Include: headline, dateline, lead paragraph, quotes from [SPOKESPERSON], company boilerplate, and contact info.",
            placeholders: ["COMPANY", "NEWS", "SPOKESPERSON"],
            category: "Writing"
        ),
        Template(
            title: "Newsletter Content",
            description: "Create engaging newsletter content",
            template: "Write a newsletter section about [TOPIC] for [AUDIENCE]. Include: catchy subject line, [NUMBER] key points, personal story/example, and call-to-action for [GOAL].",
            placeholders: ["TOPIC", "AUDIENCE", "NUMBER", "GOAL"],
            category: "Writing"
        ),
        Template(
            title: "Content Calendar",
            description: "Plan content marketing strategy",
            template: "Create a [TIMEFRAME] content calendar for [PLATFORM/CHANNEL]. Topic theme: [THEME], Target audience: [AUDIENCE], Post frequency: [FREQUENCY], Key goals: [GOALS].",
            placeholders: ["TIMEFRAME", "PLATFORM/CHANNEL", "THEME", "AUDIENCE", "FREQUENCY", "GOALS"],
            category: "Writing"
        ),
        Template(
            title: "Video Script",
            description: "Write engaging video scripts",
            template: "Write a [DURATION] video script about [TOPIC]. Target audience: [AUDIENCE], Tone: [TONE], Key message: [MESSAGE], Call-to-action: [CTA]. Include scene descriptions.",
            placeholders: ["DURATION", "TOPIC", "AUDIENCE", "TONE", "MESSAGE", "CTA"],
            category: "Writing"
        ),
        
        // More Creative Templates
        Template(
            title: "World Building",
            description: "Create fictional worlds and settings",
            template: "Create a detailed world for a [GENRE] story. Setting: [TIME_PERIOD], Geography: [GEOGRAPHY], Culture: [CULTURE], Technology level: [TECH_LEVEL], Main conflict: [CONFLICT].",
            placeholders: ["GENRE", "TIME_PERIOD", "GEOGRAPHY", "CULTURE", "TECH_LEVEL", "CONFLICT"],
            category: "Creative"
        ),
        Template(
            title: "Dialogue Generator",
            description: "Write natural character conversations",
            template: "Write a dialogue between [CHARACTER_1] and [CHARACTER_2] about [TOPIC]. Setting: [SETTING], Mood: [MOOD], [CHARACTER_1] wants: [GOAL_1], [CHARACTER_2] wants: [GOAL_2].",
            placeholders: ["CHARACTER_1", "CHARACTER_2", "TOPIC", "SETTING", "MOOD", "GOAL_1", "GOAL_2"],
            category: "Creative"
        ),
        Template(
            title: "Song Lyrics",
            description: "Create original song lyrics",
            template: "Write lyrics for a [GENRE] song about [THEME]. Mood: [MOOD], Target audience: [AUDIENCE], Include: [NUMBER] verses, chorus, and bridge. Rhyme scheme: [RHYME_SCHEME].",
            placeholders: ["GENRE", "THEME", "MOOD", "AUDIENCE", "NUMBER", "RHYME_SCHEME"],
            category: "Creative"
        ),
        Template(
            title: "Poetry Generator",
            description: "Create poems in different styles",
            template: "Write a [POEM_TYPE] poem about [SUBJECT]. Style: [STYLE], Tone: [TONE], Length: [LENGTH] lines. Include imagery of [IMAGERY] and theme of [THEME].",
            placeholders: ["POEM_TYPE", "SUBJECT", "STYLE", "TONE", "LENGTH", "IMAGERY", "THEME"],
            category: "Creative"
        ),
        
        // More Coding Templates
        Template(
            title: "Bug Report Analysis",
            description: "Analyze and solve coding issues",
            template: "Analyze this bug report: [BUG_DESCRIPTION]. Code language: [LANGUAGE], Error message: [ERROR], Expected behavior: [EXPECTED], Steps to reproduce: [STEPS]. Provide solution and prevention tips.",
            placeholders: ["BUG_DESCRIPTION", "LANGUAGE", "ERROR", "EXPECTED", "STEPS"],
            category: "Coding"
        ),
        Template(
            title: "API Documentation",
            description: "Document APIs comprehensively",
            template: "Create API documentation for [API_NAME]. Endpoint: [ENDPOINT], Method: [METHOD], Parameters: [PARAMETERS], Response format: [RESPONSE], Authentication: [AUTH]. Include examples.",
            placeholders: ["API_NAME", "ENDPOINT", "METHOD", "PARAMETERS", "RESPONSE", "AUTH"],
            category: "Coding"
        ),
        Template(
            title: "Code Optimization",
            description: "Optimize code performance",
            template: "Optimize this [LANGUAGE] code for [OPTIMIZATION_GOAL]: [CODE]. Current performance: [CURRENT_PERF], Target: [TARGET_PERF]. Focus on [FOCUS_AREAS].",
            placeholders: ["LANGUAGE", "OPTIMIZATION_GOAL", "CODE", "CURRENT_PERF", "TARGET_PERF", "FOCUS_AREAS"],
            category: "Coding"
        ),
        Template(
            title: "Testing Strategy",
            description: "Plan comprehensive testing approaches",
            template: "Create a testing strategy for [PROJECT/FEATURE]. Testing types needed: [TEST_TYPES], Tools: [TOOLS], Coverage goal: [COVERAGE], Timeline: [TIMELINE], Risk areas: [RISKS].",
            placeholders: ["PROJECT/FEATURE", "TEST_TYPES", "TOOLS", "COVERAGE", "TIMELINE", "RISKS"],
            category: "Coding"
        ),
        
        // Education Templates
        Template(
            title: "Lesson Plan",
            description: "Create structured educational content",
            template: "Create a [DURATION] lesson plan on [TOPIC] for [GRADE_LEVEL]. Learning objectives: [OBJECTIVES], Activities: [ACTIVITIES], Materials: [MATERIALS], Assessment: [ASSESSMENT].",
            placeholders: ["DURATION", "TOPIC", "GRADE_LEVEL", "OBJECTIVES", "ACTIVITIES", "MATERIALS", "ASSESSMENT"],
            category: "Education"
        ),
        Template(
            title: "Study Guide",
            description: "Generate comprehensive study materials",
            template: "Create a study guide for [SUBJECT] covering [TOPICS]. Format: [FORMAT], Target exam: [EXAM], Key concepts: [CONCEPTS], Practice questions: [QUESTIONS], Study timeline: [TIMELINE].",
            placeholders: ["SUBJECT", "TOPICS", "FORMAT", "EXAM", "CONCEPTS", "QUESTIONS", "TIMELINE"],
            category: "Education"
        ),
        Template(
            title: "Research Proposal",
            description: "Structure academic research proposals",
            template: "Write a research proposal on [RESEARCH_TOPIC]. Research question: [QUESTION], Methodology: [METHODOLOGY], Literature gap: [GAP], Expected outcomes: [OUTCOMES], Timeline: [TIMELINE].",
            placeholders: ["RESEARCH_TOPIC", "QUESTION", "METHODOLOGY", "GAP", "OUTCOMES", "TIMELINE"],
            category: "Education"
        ),
        
        // Personal Templates
        Template(
            title: "Goal Setting",
            description: "Create actionable personal goals",
            template: "Help me create a [TIMEFRAME] goal plan for [GOAL_AREA]. Current situation: [CURRENT], Desired outcome: [DESIRED], Obstacles: [OBSTACLES], Resources: [RESOURCES], Success metrics: [METRICS].",
            placeholders: ["TIMEFRAME", "GOAL_AREA", "CURRENT", "DESIRED", "OBSTACLES", "RESOURCES", "METRICS"],
            category: "Personal"
        ),
        Template(
            title: "Decision Making",
            description: "Analyze decisions systematically",
            template: "Help me decide between [OPTION_1] and [OPTION_2] for [DECISION_CONTEXT]. Criteria: [CRITERIA], Constraints: [CONSTRAINTS], Timeline: [TIMELINE], Stakeholders: [STAKEHOLDERS].",
            placeholders: ["OPTION_1", "OPTION_2", "DECISION_CONTEXT", "CRITERIA", "CONSTRAINTS", "TIMELINE", "STAKEHOLDERS"],
            category: "Personal"
        ),
        Template(
            title: "Travel Itinerary",
            description: "Plan detailed travel schedules",
            template: "Create a [DURATION] travel itinerary for [DESTINATION]. Budget: [BUDGET], Interests: [INTERESTS], Travel style: [STYLE], Must-see: [MUST_SEE], Dietary restrictions: [DIETARY].",
            placeholders: ["DURATION", "DESTINATION", "BUDGET", "INTERESTS", "STYLE", "MUST_SEE", "DIETARY"],
            category: "Personal"
        ),
        Template(
            title: "Learning Plan",
            description: "Structure personal learning journeys",
            template: "Create a learning plan for [SKILL/SUBJECT]. Current level: [CURRENT_LEVEL], Goal level: [TARGET_LEVEL], Timeline: [TIMELINE], Learning style: [STYLE], Available time: [TIME_COMMITMENT].",
            placeholders: ["SKILL/SUBJECT", "CURRENT_LEVEL", "TARGET_LEVEL", "TIMELINE", "STYLE", "TIME_COMMITMENT"],
            category: "Personal"
        ),
        
        // Marketing Templates
        Template(
            title: "Ad Copy",
            description: "Create compelling advertising copy",
            template: "Write ad copy for [PRODUCT/SERVICE] on [PLATFORM]. Target audience: [AUDIENCE], Key benefit: [BENEFIT], Emotional trigger: [EMOTION], Call-to-action: [CTA], Character limit: [LIMIT].",
            placeholders: ["PRODUCT/SERVICE", "PLATFORM", "AUDIENCE", "BENEFIT", "EMOTION", "CTA", "LIMIT"],
            category: "Marketing"
        ),
        Template(
            title: "Customer Persona",
            description: "Define target customer profiles",
            template: "Create a customer persona for [PRODUCT/SERVICE]. Demographics: [DEMOGRAPHICS], Pain points: [PAIN_POINTS], Goals: [GOALS], Behavior: [BEHAVIOR], Preferred channels: [CHANNELS].",
            placeholders: ["PRODUCT/SERVICE", "DEMOGRAPHICS", "PAIN_POINTS", "GOALS", "BEHAVIOR", "CHANNELS"],
            category: "Marketing"
        ),
        Template(
            title: "Campaign Strategy",
            description: "Plan marketing campaign strategies",
            template: "Design a [CAMPAIGN_TYPE] campaign for [PRODUCT/SERVICE]. Objective: [OBJECTIVE], Budget: [BUDGET], Timeline: [TIMELINE], Channels: [CHANNELS], Success metrics: [METRICS].",
            placeholders: ["CAMPAIGN_TYPE", "PRODUCT/SERVICE", "OBJECTIVE", "BUDGET", "TIMELINE", "CHANNELS", "METRICS"],
            category: "Marketing"
        ),
        
        // Analysis Templates
        Template(
            title: "SWOT Analysis",
            description: "Conduct comprehensive SWOT analysis",
            template: "Perform a SWOT analysis for [COMPANY/PROJECT]. Internal factors - Strengths: [STRENGTHS], Weaknesses: [WEAKNESSES]. External factors - Opportunities: [OPPORTUNITIES], Threats: [THREATS].",
            placeholders: ["COMPANY/PROJECT", "STRENGTHS", "WEAKNESSES", "OPPORTUNITIES", "THREATS"],
            category: "Analysis"
        ),
        Template(
            title: "Data Interpretation",
            description: "Analyze and interpret data sets",
            template: "Analyze this data about [DATA_SUBJECT]: [DATA]. Context: [CONTEXT], Key questions: [QUESTIONS], Target audience: [AUDIENCE]. Provide insights, trends, and [NUMBER] recommendations.",
            placeholders: ["DATA_SUBJECT", "DATA", "CONTEXT", "QUESTIONS", "AUDIENCE", "NUMBER"],
            category: "Analysis"
        ),
        Template(
            title: "Competitive Analysis",
            description: "Compare competitors systematically",
            template: "Compare [YOUR_PRODUCT] with competitors [COMPETITOR_1] and [COMPETITOR_2]. Analyze: features, pricing, market position, strengths/weaknesses. Focus on [COMPARISON_CRITERIA].",
            placeholders: ["YOUR_PRODUCT", "COMPETITOR_1", "COMPETITOR_2", "COMPARISON_CRITERIA"],
            category: "Analysis"
        )
    ]
}