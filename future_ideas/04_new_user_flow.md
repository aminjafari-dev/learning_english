# New User Flow Design

## Overview
Redesign the entire user journey from onboarding to daily usage, making it more engaging and intuitive.

## Current Flow Issues
- Users land on bottom navigation after sign-in
- Must repeatedly select level and focus areas
- No clear learning progression
- Boring and repetitive experience

## New User Flow

### First-Time Users (Onboarding)

#### 1. Splash Screen
- Brief loading with app branding
- Check authentication status
- Smooth transition to next step

#### 2. Authentication
- Google Sign-In (if not authenticated)
- Quick and seamless process
- Welcome message after successful sign-in

#### 3. Welcome & Goal Setting
- **Welcome Screen**: "Let's personalize your English learning journey"
- **Quick 3-Question Setup**:
  - What's your main goal? (Work, Travel, Study, etc.)
  - How much time can you study daily? (10/20/30+ minutes)
  - What's your current level? (Beginner, Intermediate, Advanced)

#### 4. Add First Learning Path
- **Focus Area Selection**: Choose your first learning path
- **Level Confirmation**: Confirm or adjust your level
- **Path Preview**: Show what you'll learn in this path

#### 5. Personalization Survey (Optional)
- **Detailed Preferences**: Extended questionnaire
- **Skip Option**: "I'll set this up later"
- **Progressive Profiling**: Ask more questions over time

#### 6. My Learning Paths (Main Landing)
- **Path Card**: Shows your selected learning path
- **Progress Ring**: Visual progress indicator
- **Continue Button**: "Start Lesson 1" or "Continue Lesson X"
- **Add More Paths**: Option to add additional focus areas

### Returning Users

#### 1. Splash Screen
- Brief loading (1-2 seconds)
- Check for updates or new content

#### 2. My Learning Paths (Direct Landing)
- **Current Progress**: Where you left off
- **Continue Learning**: Clear next step
- **Path Overview**: All your active learning paths
- **Quick Actions**: Add new path, view history, settings

## Navigation Structure

### Bottom Navigation Bar
- **Paths** (Default Tab): My Learning Paths page
- **History**: Learning history and analytics
- **Profile**: Settings, preferences, account

### Path Cards Layout
```
┌─────────────────────────────────┐
│ Business English Path           │
│ ●●●○○○○○○○ 30% Complete        │
│                                 │
│ Current: Unit 2 • Lesson 3      │
│ Next: "Email Etiquette"         │
│                                 │
│ [Continue Learning] [View Path] │
└─────────────────────────────────┘
```

### Empty State (No Paths)
```
┌─────────────────────────────────┐
│                                 │
│        📚                       │
│                                 │
│   Start Your Learning Journey   │
│                                 │
│  Choose a focus area to begin   │
│                                 │
│      [Add Learning Path]        │
│                                 │
└─────────────────────────────────┘
```

## Key Improvements

### Clear Next Steps
- Always show what to do next
- Prominent "Continue" buttons
- Progress indicators everywhere

### Reduced Friction
- No repeated level/focus selection
- One-tap access to continue learning
- Streamlined onboarding process

### Visual Hierarchy
- Path cards as primary content
- Clear progress visualization
- Intuitive navigation patterns

### Personalization
- Tailored content from day one
- Adaptive based on user preferences
- Progressive profiling over time

## Implementation Priority

### Phase 1: Core Flow
- New onboarding sequence
- My Learning Paths page
- Updated navigation structure

### Phase 2: Enhanced UX
- Progress visualization
- Empty states and loading
- Smooth transitions

### Phase 3: Advanced Features
- Progressive profiling
- Smart recommendations
- Advanced personalization

## Success Metrics
- **Onboarding Completion**: 90%+ complete full setup
- **Time to First Lesson**: <2 minutes from app open
- **Return Engagement**: 80%+ return within 24 hours
- **Navigation Clarity**: Reduced support tickets about navigation
