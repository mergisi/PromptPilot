//
//  MixpanelConfig.swift
//  PromptPilot
//
//  Created by AI Assistant on 9/15/25.
//

import Foundation

struct MixpanelConfig {
    // MARK: - Configuration
    // TODO: Replace with your actual Mixpanel project token from https://mixpanel.com/settings/project
    static let projectToken = "dfa279884d8025cc9fb8a781e3bcd97a"
    
    // Optional: Use different tokens for different environments
    static let debugToken = "YOUR_DEBUG_TOKEN_HERE" // Optional debug token
    
    // Get the appropriate token based on build configuration
    static var token: String {
        #if DEBUG
        return debugToken.isEmpty || debugToken == "YOUR_DEBUG_TOKEN_HERE" ? projectToken : debugToken
        #else
        return projectToken
        #endif
    }
    
    // MARK: - Instructions
    /*
     To set up Mixpanel tracking:
     
     1. Sign up for Mixpanel at https://mixpanel.com
     2. Create a new project or use an existing one
     3. Go to Settings > Project Settings
     4. Copy your "Project Token"
     5. Replace "YOUR_MIXPANEL_TOKEN_HERE" above with your actual token
     
     Example:
     static let projectToken = "abc123def456ghi789jkl012mno345pqr"
     
     Optional: You can also set up a separate token for debug builds to keep
     development data separate from production data.
     */
}
