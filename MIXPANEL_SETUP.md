# Mixpanel Analytics Setup for PromptPilot

## Overview

I've successfully integrated Mixpanel analytics into your PromptPilot app to track important events that lead to purchases. This will help you understand user behavior and optimize your conversion funnel.

## 🎯 Key Events Being Tracked

### Premium/Purchase Funnel Events
- **Premium View Shown** - When users see the premium upgrade screen
- **Purchase Attempted** - When users tap monthly/yearly purchase buttons
- **Purchase Completed** - When purchases are successful
- **Purchase Failed** - When purchases fail (with error details)
- **Restore Purchases Attempted/Completed** - When users restore previous purchases

### Limit Reached Events (Critical for Conversions)
- **Collection Limit Reached** - When free users hit the 2 collection limit
- **Favorite Limit Reached** - When free users hit the 10 favorite limit
- **Import Limit Reached** - When free users hit the 5 import limit
- **Collection Prompt Limit Reached** - When free users hit the 10 prompts per collection limit

### User Engagement Events
- **App Launched** - App startup tracking
- **Prompt Viewed** - When users view prompt details
- **Prompt Copied** - When users copy prompts to clipboard
- **Prompt Shared to AI** - When users open prompts in ChatGPT/Claude/Gemini
- **Prompt Imported** - When users import new prompts
- **Collection Created** - When users create new collections
- **Favorite Toggled** - When users add/remove favorites

## 🛠 Setup Instructions

### Step 1: Get Your Mixpanel Token
1. Sign up for Mixpanel at [https://mixpanel.com](https://mixpanel.com)
2. Create a new project (or use existing)
3. Go to **Settings > Project Settings**
4. Copy your **Project Token**

### Step 2: Configure the Token
1. Open `PromptPilot/MixpanelConfig.swift`
2. Replace `"YOUR_MIXPANEL_TOKEN_HERE"` with your actual token:

```swift
static let projectToken = "abc123def456ghi789jkl012mno345pqr" // Your actual token
```

### Step 3: Optional Debug Token
For development/testing, you can set up a separate debug token:

```swift
static let debugToken = "your_debug_token_here" // Optional
```

### Step 4: Build and Run
The analytics will start working immediately once you build and run the app with your token configured.

## 📊 Key Metrics to Monitor

### Conversion Funnel
1. **App Launched** → **Premium View Shown** (conversion rate)
2. **Premium View Shown** → **Purchase Attempted** (intent rate)
3. **Purchase Attempted** → **Purchase Completed** (success rate)

### Limit-Driven Conversions
Track which limits drive the most premium upgrades:
- Collection Limit → Premium View Shown
- Favorite Limit → Premium View Shown
- Import Limit → Premium View Shown

### User Engagement
- Most copied prompts (identify popular content)
- Most used AI platforms (ChatGPT vs Claude vs Gemini)
- Import patterns (manual imports)

## 🔧 Files Modified

### New Files Created:
- `MixpanelManager.swift` - Main analytics manager
- `MixpanelConfig.swift` - Configuration file for tokens

### Modified Files:
- `project.pbxproj` - Added Mixpanel dependency
- `PremiumManager.swift` - Added purchase tracking
- `PremiumView.swift` - Added premium view tracking
- `ContentView.swift` - Added user action tracking
- `PromptPilotApp.swift` - Added app launch tracking

## 📈 Sample Mixpanel Queries

Once data starts flowing, you can create these useful queries in Mixpanel:

### Conversion Funnel
```
Premium View Shown → Purchase Attempted → Purchase Completed
```

### Limit Analysis
```
Collection Limit Reached → Premium View Shown (within 1 hour)
```

### Engagement Analysis
```
Prompt Copied (group by Prompt Category)
Prompt Shared to AI (group by AI Model)
```

## 🚀 Advanced Features Available

The implementation includes advanced tracking capabilities:

### User Properties
- Premium status (Free/Premium)
- User type tracking

### Event Properties
- Product details (monthly/yearly, pricing)
- Error tracking (purchase failures)
- Content metadata (prompt categories, AI models)
- Limit context (current count, limit values)

### Custom Events
You can easily add more events using the MixpanelManager:

```swift
// Example: Track custom engagement
MixpanelManager.shared.trackEngagementMetric(
    metric: "session_length", 
    value: 120.5,
    context: ["screen": "prompts"]
)
```

## 🛡 Privacy & Performance

- Events are batched and sent efficiently
- No personal data is tracked (only usage patterns)
- Debug logging available in development builds
- Automatic event flushing on app backgrounding

## 📞 Support

The implementation is complete and ready to use. Simply add your Mixpanel token and you'll start seeing data within minutes of users using the app.

Key conversion events to watch:
1. **Limit Reached** events (these should drive premium upgrades)
2. **Premium View Shown** → **Purchase Completed** conversion rate
3. **Purchase Failed** events (to identify and fix issues)

Happy tracking! 🎉
