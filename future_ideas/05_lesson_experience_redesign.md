# Lesson Experience Redesign

## Overview
Transform the current lesson format into an engaging, structured experience with clear progression and mastery requirements.

## Current Lesson Issues
- Generic daily lessons
- No clear structure or progression
- Limited interactivity
- No mastery requirements

## New Lesson Structure

### Lesson Format (5-8 minutes total)
```
Lesson: "Unit 3 • Lesson 2: Small Talk at Work"

1. Learn Section (2-3 minutes)
   ├── 6-8 vocabulary words with examples
   ├── 4-6 common phrases with context
   └── Audio pronunciation (if enabled)

2. Try Section (2-3 minutes)
   ├── 3-5 quick checks (tap/select/complete)
   ├── Immediate feedback
   └── Hint system (based on difficulty preference)

3. Challenge Section (1-2 minutes)
   ├── Short timed task
   ├── Scenario-based exercise
   └── Real-world application

4. End Screen
   ├── XP gained display
   ├── Streak progress
   ├── Next lesson preview
   ├── "Review tough items" option
   └── "Continue" button
```

## Detailed Section Breakdown

### 1. Learn Section
**Purpose**: Introduce new vocabulary and phrases
**Content**:
- 6-8 vocabulary words with clear definitions
- 4-6 common phrases with usage examples
- Audio pronunciation (optional based on user preference)
- Visual context (images, scenarios)

**Interaction**:
- Tap to hear pronunciation
- Swipe to see more examples
- Tap to mark as "known" or "new"

### 2. Try Section
**Purpose**: Practice and reinforce learning
**Content**:
- 3-5 interactive exercises
- Multiple choice questions
- Fill-in-the-blank exercises
- Matching activities

**Feedback**:
- Immediate correct/incorrect feedback
- Explanation for wrong answers
- Hint system (based on user preference)
- Progress indicator

### 3. Challenge Section
**Purpose**: Apply learning in real scenarios
**Content**:
- Timed exercises (30-60 seconds)
- Scenario-based tasks
- Role-playing situations
- Real-world applications

**Examples**:
- "Order coffee at a café" (Travel path)
- "Respond to a work email" (Business path)
- "Make small talk at a party" (Social path)

### 4. End Screen
**Purpose**: Celebrate progress and show next steps
**Content**:
- XP gained (with animation)
- Streak progress update
- Next lesson preview
- Achievement notifications
- Action buttons

## Mastery & Progression System

### Lesson Completion Requirements
- **Accuracy Threshold**: 80% on Try section
- **Challenge Completion**: Must complete challenge section
- **Time Limit**: No strict time limit, but encouraged pace

### Retry Logic
- **Failed Lesson**: Offer practice mode
- **Practice Mode**: Focused review of difficult items
- **Retry**: Attempt lesson again after practice
- **Skip Option**: After 3 attempts, allow skip with note

### Unit Checkpoints
- **Every 5 Lessons**: Comprehensive checkpoint
- **Checkpoint Content**: Review of all 5 lessons
- **Mastery Required**: 85% accuracy to unlock next unit
- **Retry System**: Practice mode for failed checkpoints

## Interactive Elements

### Exercise Types
1. **Multiple Choice**: Select correct answer
2. **Fill in the Blank**: Complete sentences
3. **Matching**: Connect words with definitions
4. **Drag & Drop**: Arrange words in order
5. **Audio Recognition**: Listen and select correct option
6. **Speaking Practice**: Record pronunciation (future)

### Feedback System
- **Immediate**: Right/wrong with explanation
- **Encouraging**: Positive reinforcement for correct answers
- **Educational**: Explain why wrong answers are incorrect
- **Adaptive**: Adjust difficulty based on performance

### Hint System
- **Gentle Mode**: Multiple hints available
- **Balanced Mode**: 2-3 hints per exercise
- **Hard Mode**: Minimal hints, more challenging

## Visual Design

### Lesson Header
```
┌─────────────────────────────────┐
│ Unit 3 • Lesson 2               │
│ Small Talk at Work              │
│ ●●●○○○○○○○ Progress             │
└─────────────────────────────────┘
```

### Exercise Layout
```
┌─────────────────────────────────┐
│ Complete the sentence:          │
│                                 │
│ "I'd like to _____ about the    │
│ project timeline."              │
│                                 │
│ [discuss] [talk] [speak] [say]  │
│                                 │
│ 💡 Hint: This means to have a   │
│ conversation about something    │
└─────────────────────────────────┘
```

### End Screen
```
┌─────────────────────────────────┐
│ 🎉 Great Job!                   │
│                                 │
│ +25 XP earned                   │
│ 🔥 5-day streak!                │
│                                 │
│ Next: "Email Etiquette"         │
│                                 │
│ [Review] [Continue] [Practice]  │
└─────────────────────────────────┘
```

## Accessibility Features

### Audio Support
- **Pronunciation**: Audio for all vocabulary
- **Instructions**: Audio instructions for exercises
- **Feedback**: Audio confirmation for actions

### Visual Support
- **High Contrast**: Clear visual distinction
- **Large Text**: Readable font sizes
- **Color Coding**: Consistent color scheme

### Motor Support
- **Large Touch Targets**: Easy to tap
- **Swipe Gestures**: Intuitive navigation
- **Voice Input**: Speaking exercises (future)

## Implementation Priority

### Phase 1: Core Structure
- Basic lesson format
- Simple exercises
- Progress tracking

### Phase 2: Enhanced Interactivity
- Advanced exercise types
- Hint system
- Better feedback

### Phase 3: Advanced Features
- Speaking practice
- Adaptive difficulty
- Advanced analytics

## Success Metrics
- **Completion Rate**: 85%+ lesson completion
- **Accuracy**: 80%+ average accuracy
- **Engagement**: 15+ minute average session
- **Satisfaction**: High user ratings for lesson quality
