//
//  DailyChallengeManager.swift
//  PromptPilot
//
//  Created by PromptPilot AI Assistant on 8/4/25.
//

import Foundation

class DailyChallengeManager: ObservableObject {
    @Published var todaysChallenge: DailyChallenge?
    @Published var pastChallenges: [DailyChallenge] = []
    
    private let challengeKey = "DailyChallenges"
    private let lastChallengeKey = "LastChallengeDate"
    
    static let shared = DailyChallengeManager()
    
    private init() {
        loadTodaysChallenge()
    }
    
    private func loadTodaysChallenge() {
        let today = Calendar.current.startOfDay(for: Date())
        
        // Check if we already have today's challenge
        if let lastDate = UserDefaults.standard.object(forKey: lastChallengeKey) as? Date,
           Calendar.current.isDate(lastDate, inSameDayAs: today),
           let data = UserDefaults.standard.data(forKey: challengeKey),
           let challenges = try? JSONDecoder().decode([DailyChallenge].self, from: data),
           let todayChallenge = challenges.first(where: { Calendar.current.isDate($0.date, inSameDayAs: today) }) {
            todaysChallenge = todayChallenge
        } else {
            // Generate new challenge for today
            generateNewChallenge()
        }
        
        // Load past challenges
        loadPastChallenges()
    }
    
    private func generateNewChallenge() {
        let challenges = [
            DailyChallenge(
                date: Date(),
                title: "The Storyteller Challenge",
                description: "Create a compelling narrative with specific constraints",
                difficulty: "Intermediate",
                prompt: "Write a 100-word story that includes these 3 elements: a mysterious package, a talking cat, and rain. The story must have a surprise ending.",
                hints: [
                    "Start with an intriguing opening",
                    "Build tension quickly",
                    "The surprise should reframe the entire story"
                ],
                sampleSolution: "The package arrived in the rain, addressed to no one. 'Don't open it,' warned Mittens, my cat. I laughed—cats don't talk. But as I reached for the box, Mittens spoke again: 'Please, Sarah.' My hand froze. Inside wasn't a gift, but a collar with a note: 'For the cat who forgot she was human.' Mittens' eyes filled with tears. 'Ten years I've protected you from knowing.' Thunder crashed. I looked at my hands—were those... paws? The rain washed away the illusion. We were both cats, always had been."
            ),
            DailyChallenge(
                date: Date(),
                title: "The Explainer Challenge",
                description: "Make complex topics simple and engaging",
                difficulty: "Beginner",
                prompt: "Explain how the internet works to a 5-year-old using only things found in a kitchen.",
                hints: [
                    "Use familiar objects as metaphors",
                    "Keep language very simple",
                    "Make it fun and relatable"
                ],
                sampleSolution: "Imagine the internet is like a giant recipe sharing party! Your computer is like your kitchen. When you want to see something (like a video), you send a note through pipes (like water pipes, but for information). The note goes to a big recipe library (server) that has what you want. The library sends the recipe back through the pipes, but broken into tiny pieces (like ingredients). Your kitchen (computer) puts all the pieces together, and voilà—you can watch your video! Just like following a recipe to make cookies!"
            ),
            DailyChallenge(
                date: Date(),
                title: "The Analyst Challenge",
                description: "Practice data interpretation and insight generation",
                difficulty: "Advanced",
                prompt: "A coffee shop's sales dropped 30% last month. Generate 5 specific questions you'd ask to diagnose the problem, then provide hypotheses for each.",
                hints: [
                    "Consider internal and external factors",
                    "Think about seasonal patterns",
                    "Look at competitive landscape",
                    "Consider operational changes"
                ],
                sampleSolution: "Questions & Hypotheses:\n1. Did competitor shops open nearby? → New competition may be drawing customers\n2. Were there any menu or price changes? → Price increases might have driven customers away\n3. Did key staff members leave? → Service quality may have declined\n4. Were there any equipment failures? → Inconsistent product quality could impact sales\n5. Did foot traffic in the area change? → Construction, events, or seasonal changes might affect customer flow"
            ),
            DailyChallenge(
                date: Date(),
                title: "The Coder's Challenge",
                description: "Write prompts for code generation and debugging",
                difficulty: "Intermediate",
                prompt: "Create a prompt that would generate a Python function to validate email addresses. Include edge cases and error handling requirements.",
                hints: [
                    "Specify the validation rules clearly",
                    "Mention return types",
                    "Include test cases",
                    "Request documentation"
                ],
                sampleSolution: "Write a Python function called 'validate_email' that:\n- Takes a string as input\n- Returns True if valid, False otherwise\n- Checks for: @ symbol, domain extension, valid characters\n- Handles edge cases: empty string, None, multiple @\n- Includes docstring with examples\n- Add 5 test cases showing valid and invalid emails\n- Use regex for validation\n- Raise TypeError for non-string inputs"
            ),
            DailyChallenge(
                date: Date(),
                title: "The Persuader Challenge",
                description: "Craft compelling arguments and persuasive content",
                difficulty: "Intermediate",
                prompt: "Write a 150-word pitch convincing someone to learn a new language. Make it personal, specific, and actionable.",
                hints: [
                    "Start with a relatable problem or desire",
                    "Use specific benefits, not generic ones",
                    "Include a clear call-to-action",
                    "Address common objections"
                ],
                sampleSolution: "Remember that trip to Barcelona where you could only point at menu items? Learning Spanish changes everything. In just 15 minutes daily, you'll go from tourist to traveler. Start with DuoLingo's free app—it's like a game. Within 3 months, you'll order tapas like a local, understand street signs, and actually connect with people. Yes, you're busy, but you scroll social media for 30 minutes daily—swap half for Spanish. You're not 'bad at languages'—you just haven't found the right method. Skip traditional textbooks; use Netflix with Spanish subtitles, listen to Spanish podcasts during commutes. That promotion requiring bilingual skills? That dream of living abroad? They're waiting. Download DuoLingo now, set a daily reminder for 8 PM, and commit to a 30-day streak. Your future self will thank you."
            )
        ]
        
        // Select a random challenge or cycle through them
        let randomIndex = Int.random(in: 0..<challenges.count)
        var newChallenge = challenges[randomIndex]
        
        // Update the date to today
        newChallenge = DailyChallenge(
            date: Calendar.current.startOfDay(for: Date()),
            title: newChallenge.title,
            description: newChallenge.description,
            difficulty: newChallenge.difficulty,
            prompt: newChallenge.prompt,
            hints: newChallenge.hints,
            sampleSolution: newChallenge.sampleSolution
        )
        
        todaysChallenge = newChallenge
        saveChallenge(newChallenge)
    }
    
    private func saveChallenge(_ challenge: DailyChallenge) {
        var allChallenges = loadAllChallenges()
        
        // Remove any existing challenge for today
        allChallenges.removeAll { Calendar.current.isDate($0.date, inSameDayAs: challenge.date) }
        
        // Add new challenge
        allChallenges.append(challenge)
        
        // Keep only last 30 days of challenges
        let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: Date())!
        allChallenges = allChallenges.filter { $0.date > thirtyDaysAgo }
        
        // Save to UserDefaults
        if let encoded = try? JSONEncoder().encode(allChallenges) {
            UserDefaults.standard.set(encoded, forKey: challengeKey)
            UserDefaults.standard.set(challenge.date, forKey: lastChallengeKey)
        }
    }
    
    private func loadAllChallenges() -> [DailyChallenge] {
        guard let data = UserDefaults.standard.data(forKey: challengeKey),
              let challenges = try? JSONDecoder().decode([DailyChallenge].self, from: data) else {
            return []
        }
        return challenges
    }
    
    private func loadPastChallenges() {
        let allChallenges = loadAllChallenges()
        let today = Calendar.current.startOfDay(for: Date())
        pastChallenges = allChallenges
            .filter { !Calendar.current.isDate($0.date, inSameDayAs: today) }
            .sorted { $0.date > $1.date }
    }
    
    func refreshChallenge() {
        loadTodaysChallenge()
    }
}