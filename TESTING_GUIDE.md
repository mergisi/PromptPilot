# 🧪 Complete Testing Guide - Before App Store Publish

## 🚨 **IMPORTANT: ID Issue Fixed**

You keep using the **App ID** (`~9361812948`) instead of **Ad Unit ID**. I've switched back to Google's test ID for proper testing.

**Remember:**
- ❌ **App ID**: `ca-app-pub-5223337070047795~9361812948` (ends with `~`) → Goes in Info.plist
- ✅ **Ad Unit ID**: `ca-app-pub-5223337070047795/XXXXXXX` (ends with `/`) → Goes in AdMobConfig.swift

## 📱 **Testing Strategy: 3 Phases**

### **Phase 1: Local Testing (Current Setup)**
### **Phase 2: TestFlight Testing** 
### **Phase 3: Production Ready**

---

## 🔧 **Phase 1: Local Testing (START HERE)**

### **Current Setup - Ready to Test:**
```swift
// AdMobConfig.swift - CURRENT (Test Ads)
static let bannerAdUnitID = "ca-app-pub-3940256099942544/2934735716"
```

### **1. Build and Run on Simulator/Device**

```bash
# Clean build
xcodebuild clean -project PromptPilot.xcodeproj -scheme PromptPilot

# Build for simulator
xcodebuild -project PromptPilot.xcodeproj -scheme PromptPilot -destination 'platform=iOS Simulator,name=iPhone 15 Pro' build

# Or build for device
xcodebuild -project PromptPilot.xcodeproj -scheme PromptPilot -destination 'generic/platform=iOS' build
```

### **2. What to Test - Local**

#### **✅ Ad Display Testing:**
- [ ] **Free user**: See test banner ads at bottom of each tab
- [ ] **Premium user**: No ads visible
- [ ] **Ad loading**: Check console for "Test Ad" labels
- [ ] **App stability**: No crashes when ads load/fail

#### **✅ Purchase Flow Testing:**
- [ ] **Premium screen**: Plan selection works
- [ ] **Purchase attempt**: StoreKit sandbox works
- [ ] **Mixpanel tracking**: Events logged correctly
- [ ] **Ad removal**: Ads disappear after premium purchase

#### **✅ Core App Testing:**
- [ ] **Prompt browsing**: All categories work
- [ ] **Favorites**: Add/remove prompts
- [ ] **Import**: Custom prompt import
- [ ] **Collections**: Create/manage collections
- [ ] **Sora 2**: New category appears with prompts

### **3. Console Logs to Look For:**

#### **✅ Good Logs:**
```
AdMob: Test Ad loaded successfully
Mixpanel: Event tracked - app_launched
StoreKit: Sandbox purchase initiated
```

#### **❌ Error Logs:**
```
AdMob: Failed to load ad - Invalid Ad Unit ID
Mixpanel: Failed to track event
StoreKit: Purchase failed
```

---

## 🚀 **Phase 2: TestFlight Testing**

### **Setup for TestFlight:**

#### **1. Create Production Ad Unit ID**
1. **AdMob Console** → **Apps** → **Your App**
2. **Ad Units** → **Add Ad Unit** → **Banner**
3. **Copy the ID** (format: `ca-app-pub-5223337070047795/XXXXXXX`)

#### **2. Update Configuration**
```swift
// AdMobConfig.swift - PRODUCTION
static let bannerAdUnitID = "ca-app-pub-5223337070047795/YOUR_REAL_ID"
```

#### **3. Build for TestFlight**
```bash
# Archive for TestFlight
xcodebuild -project PromptPilot.xcodeproj -scheme PromptPilot -configuration Release -destination 'generic/platform=iOS' archive -archivePath PromptPilot.xcarchive

# Upload to App Store Connect (via Xcode or Transporter)
```

### **TestFlight Testing Checklist:**

#### **✅ Real Ad Testing:**
- [ ] **Real ads display** (not test ads)
- [ ] **Ad revenue tracking** in AdMob console
- [ ] **App-ads.txt verification** working
- [ ] **No crashes** with real ads

#### **✅ Production Purchase Testing:**
- [ ] **Real StoreKit** (not sandbox)
- [ ] **Premium features** unlock correctly
- [ ] **Ad removal** after purchase
- [ ] **Receipt validation** working

#### **✅ Analytics Testing:**
- [ ] **Mixpanel events** in production dashboard
- [ ] **Purchase funnel** tracking correctly
- [ ] **User behavior** data flowing

---

## 🎯 **Phase 3: Production Ready**

### **Final Pre-Launch Checklist:**

#### **✅ Technical:**
- [ ] **Real Ad Unit IDs** in production build
- [ ] **App-ads.txt** uploaded to website
- [ ] **Info.plist** has correct App ID
- [ ] **All packages** resolved and building
- [ ] **No test/debug code** remaining

#### **✅ Content:**
- [ ] **Sora 2 prompts** working correctly
- [ ] **All categories** populated
- [ ] **Premium features** properly gated
- [ ] **UI/UX** polished and tested

#### **✅ Business:**
- [ ] **AdMob account** approved and active
- [ ] **App Store metadata** complete
- [ ] **Privacy policy** updated for ads
- [ ] **Terms of service** current

---

## 🛠 **Quick Test Commands**

### **Run Local Tests:**
```bash
# Build and run simulator
open -a Simulator
xcodebuild -project PromptPilot.xcodeproj -scheme PromptPilot -destination 'platform=iOS Simulator,name=iPhone 15 Pro' build

# Check for issues
xcodebuild -project PromptPilot.xcodeproj -scheme PromptPilot analyze
```

### **TestFlight Build:**
```bash
# Clean and archive
xcodebuild clean -project PromptPilot.xcodeproj -scheme PromptPilot
xcodebuild -project PromptPilot.xcodeproj -scheme PromptPilot -configuration Release archive -archivePath ./build/PromptPilot.xcarchive
```

### **Check Dependencies:**
```bash
# Verify packages
xcodebuild -resolvePackageDependencies -project PromptPilot.xcodeproj
```

---

## 🔍 **Debugging Common Issues**

### **Ads Not Showing:**
1. **Check Ad Unit ID format** (must end with `/`)
2. **Verify AdMob account** is approved
3. **Check console logs** for specific errors
4. **Test with Google test IDs** first

### **Purchase Flow Issues:**
1. **StoreKit sandbox** configured correctly
2. **Products** created in App Store Connect
3. **Test account** signed in to device
4. **Network connectivity** stable

### **Build Errors:**
1. **Clean build folder** (⌘+Shift+K)
2. **Resolve packages** in Xcode
3. **Check provisioning** profiles
4. **Verify code signing**

---

## 🎉 **Ready to Test!**

**Current Status:**
- ✅ **Test Ad Unit ID** configured
- ✅ **All packages** should be resolved
- ✅ **Banner implementation** ready
- ✅ **Premium logic** implemented

**Start with Phase 1 local testing, then move to TestFlight when ready!**

Run the build command above and let me know what you see in the console logs! 🚀
