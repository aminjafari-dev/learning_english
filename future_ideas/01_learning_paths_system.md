# Learning Paths System

## Overview
Transform the current daily lessons into structured learning paths with AI-generated sub-categories and course progression. Users start with a simple level + focus selection, then choose from AI-generated sub-areas, and progress through 20 locked courses.

## Current State
- Users select level and focus areas
- Navigate to bottom navigation with separate tabs
- Daily lessons are generic and not structured

## New User Flow

### Step 1: Landing Page (Bottom Navigation Home)
- **Empty State**: Large "Add" card in center of screen
- **Action**: User taps "Add" button to start learning path creation
- **Visual**: Clean, minimal design with prominent call-to-action

### Step 2: Level & Focus Selection
- **Level Selection**: Beginner, Intermediate, Advanced
- **Focus Area Selection**: Business, Travel, Social, Academic, etc.
- **Action**: User confirms selections and proceeds to sub-category generation

### Step 3: AI-Generated Sub-Categories
- **AI Processing**: Gemini generates relevant sub-categories based on level + focus
- **Display**: User sees 4-6 sub-category options
- **Selection**: User chooses one sub-category to focus on
- **Example**: Business + Intermediate → "Meetings", "Negotiations", "Email Writing", "Presentations"

### Step 4: Course Selection (1-20)
- **Course Grid**: Shows 20 courses in a grid layout
- **Lock Status**: Only Course 1 is unlocked, others show lock icon
- **Visual**: Clear progression indicator (1/20, 2/20, etc.)
- **Action**: User taps Course 1 to start learning

### Step 5: Daily Lesson Page
- **Content**: Vocabulary and phrases related to selected sub-category
- **Format**: Same as current daily lessons but tailored to sub-category
- **Progression**: Complete lesson → unlock next course

## AI Integration: Gemini Prompt System

### Prompt Template
```
You are an English learning curriculum expert. Generate 4-6 relevant sub-categories for English learning based on the user's level and focus area.

User Level: {LEVEL} (Beginner/Intermediate/Advanced)
Focus Area: {FOCUS_AREA} (Business/Travel/Social/Academic/etc.)

Requirements:
- Sub-categories should be specific and actionable
- Difficulty should match the user's level
- Each sub-category should have 20 lessons worth of content
- Sub-categories should be distinct but complementary
- Include brief descriptions for each sub-category

Respond ONLY with valid JSON in this exact format:
{
  "subCategories": [
    {
      "id": "unique_id",
      "title": "Sub-category Title",
      "description": "Brief description of what user will learn",
      "difficulty": "Beginner/Intermediate/Advanced",
      "estimatedLessons": 20,
      "keyTopics": ["topic1", "topic2", "topic3"]
    }
  ]
}
```

### Example Prompts & Responses

#### Business + Intermediate
```
User Level: Intermediate
Focus Area: Business

Generate 4-6 relevant sub-categories for English learning...
```

**Expected Response:**
```json
{
  "subCategories": [
    {
      "id": "meetings_intermediate",
      "title": "Meetings & Discussions",
      "description": "Master professional meeting vocabulary, phrases for leading discussions, and expressing opinions in business settings",
      "difficulty": "Intermediate",
      "estimatedLessons": 20,
      "keyTopics": ["meeting preparation", "leading discussions", "expressing opinions", "handling disagreements"]
    },
    {
      "id": "negotiations_intermediate",
      "title": "Negotiations & Deals",
      "description": "Learn negotiation tactics, deal-making vocabulary, and persuasive language for business negotiations",
      "difficulty": "Intermediate",
      "estimatedLessons": 20,
      "keyTopics": ["negotiation strategies", "persuasive language", "deal closing", "compromise solutions"]
    },
    {
      "id": "email_writing_intermediate",
      "title": "Professional Email Writing",
      "description": "Write effective business emails, from formal requests to follow-ups and professional correspondence",
      "difficulty": "Intermediate",
      "estimatedLessons": 20,
      "keyTopics": ["email structure", "formal tone", "follow-up emails", "email etiquette"]
    },
    {
      "id": "presentations_intermediate",
      "title": "Presentations & Public Speaking",
      "description": "Deliver confident presentations, handle Q&A sessions, and use visual aids effectively in business settings",
      "difficulty": "Intermediate",
      "estimatedLessons": 20,
      "keyTopics": ["presentation structure", "visual aids", "Q&A handling", "confidence building"]
    }
  ]
}
```

#### Travel + Beginner
```
User Level: Beginner
Focus Area: Travel

Generate 4-6 relevant sub-categories for English learning...
```

**Expected Response:**
```json
{
  "subCategories": [
    {
      "id": "airport_basics_beginner",
      "title": "Airport & Transportation",
      "description": "Essential vocabulary for navigating airports, booking tickets, and using public transportation",
      "difficulty": "Beginner",
      "estimatedLessons": 20,
      "keyTopics": ["check-in process", "boarding passes", "baggage claim", "public transport"]
    },
    {
      "id": "hotel_accommodation_beginner",
      "title": "Hotels & Accommodation",
      "description": "Book rooms, check in/out, request services, and handle common hotel situations",
      "difficulty": "Beginner",
      "estimatedLessons": 20,
      "keyTopics": ["room booking", "check-in process", "hotel services", "complaints"]
    },
    {
      "id": "restaurant_dining_beginner",
      "title": "Restaurants & Dining",
      "description": "Order food, ask about ingredients, pay bills, and handle dining situations confidently",
      "difficulty": "Beginner",
      "estimatedLessons": 20,
      "keyTopics": ["menu reading", "ordering food", "dietary restrictions", "paying bills"]
    },
    {
      "id": "shopping_basics_beginner",
      "title": "Shopping & Souvenirs",
      "description": "Shop for essentials, ask for help, compare prices, and buy souvenirs",
      "difficulty": "Beginner",
      "estimatedLessons": 20,
      "keyTopics": ["asking for help", "price comparison", "sizes and colors", "payment methods"]
    }
  ]
}
```

## Course Structure (20 Courses per Sub-Category)

### Course Progression
- **Course 1**: Always unlocked (introduction to sub-category)
- **Courses 2-20**: Locked until previous course is completed
- **Visual Indicator**: Lock icon + course number
- **Progress**: "1/20", "2/20", etc.

### Course Content Structure
Each course contains:
- **Vocabulary**: 8-12 relevant words with definitions
- **Phrases**: 6-8 common phrases with examples
- **Context**: Real-world usage scenarios
- **Difficulty**: Matches user's selected level

### Course Unlock Logic
```
Course 1: Always available
Course 2: Complete Course 1 (80% accuracy)
Course 3: Complete Course 2 (80% accuracy)
...
Course 20: Complete Course 19 (80% accuracy)
```

## UI/UX Design Specifications

### Landing Page (Empty State)
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

### Sub-Category Selection
```
┌─────────────────────────────────┐
│ Choose Your Focus Area          │
│                                 │
│ ┌─────────────────────────────┐ │
│ │ Meetings & Discussions      │ │
│ │ Master professional meeting │ │
│ │ vocabulary and phrases      │ │
│ └─────────────────────────────┘ │
│                                 │
│ ┌─────────────────────────────┐ │
│ │ Negotiations & Deals        │ │
│ │ Learn negotiation tactics   │ │
│ │ and persuasive language     │ │
│ └─────────────────────────────┘ │
│                                 │
│        [Continue]               │
└─────────────────────────────────┘
```

### Course Grid (1-20)
```
┌─────────────────────────────────┐
│ Meetings & Discussions          │
│ Progress: 0/20 courses          │
│                                 │
│ [1] [🔒] [🔒] [🔒] [🔒]        │
│ [🔒] [🔒] [🔒] [🔒] [🔒]        │
│ [🔒] [🔒] [🔒] [🔒] [🔒]        │
│ [🔒] [🔒] [🔒] [🔒] [🔒]        │
│                                 │
│ Course 1: Meeting Basics        │
│ [Start Learning]                │
└─────────────────────────────────┘
```

## Technical Implementation

### Data Models
```dart
class LearningPath {
  final String id;
  final String title;
  final String description;
  final Level level;
  final FocusArea focusArea;
  final List<SubCategory> subCategories;
  final DateTime createdAt;
}

class SubCategory {
  final String id;
  final String title;
  final String description;
  final Level difficulty;
  final int estimatedLessons;
  final List<String> keyTopics;
}

class Course {
  final String id;
  final int courseNumber;
  final String title;
  final String description;
  final bool isUnlocked;
  final bool isCompleted;
  final List<Vocabulary> vocabulary;
  final List<Phrase> phrases;
}
```

### API Integration
```dart
class GeminiService {
  Future<List<SubCategory>> generateSubCategories({
    required Level level,
    required FocusArea focusArea,
  }) async {
    final prompt = _buildPrompt(level, focusArea);
    final response = await _geminiClient.generateContent(prompt);
    return _parseSubCategories(response);
  }
}
```

## Additional Considerations & Suggestions

### What You Might Have Missed

#### 1. Error Handling
- **AI Failure**: What if Gemini doesn't respond or gives invalid JSON?
- **Fallback**: Pre-defined sub-categories for each level/focus combination
- **Retry Logic**: Allow users to regenerate sub-categories

#### 2. User Experience
- **Loading States**: Show loading while AI generates sub-categories
- **Preview**: Let users see a sample lesson before committing
- **Change Mind**: Allow users to go back and select different sub-category

#### 3. Content Quality
- **Validation**: Ensure AI-generated content is appropriate for level
- **Consistency**: Maintain consistent difficulty across courses
- **Review Process**: Human review of AI-generated content

#### 4. Progress Tracking
- **Course Completion**: Track which courses are completed
- **Time Tracking**: How long each course takes
- **Performance**: Accuracy rates per course
- **Resume**: Allow users to continue where they left off

#### 5. Personalization
- **Adaptive Difficulty**: Adjust based on user performance
- **Weak Areas**: Focus on areas where user struggles
- **Learning Style**: Adapt to user's preferred learning method

#### 6. Social Features
- **Progress Sharing**: Share completed courses
- **Leaderboards**: Compare progress with friends
- **Study Groups**: Learn with others in same sub-category

#### 7. Offline Support
- **Download Courses**: Allow offline access to completed courses
- **Sync**: Sync progress when back online
- **Caching**: Cache AI responses for faster loading

#### 8. Analytics
- **Completion Rates**: Track which sub-categories are most popular
- **Drop-off Points**: Identify where users stop learning
- **Performance Metrics**: Measure learning effectiveness

### Suggested Improvements

#### 1. Enhanced AI Prompt
```
Add these requirements to your prompt:
- Include cultural context for the focus area
- Consider common mistakes for the level
- Provide real-world scenarios
- Include pronunciation tips for key words
```

#### 2. Course Preview
- Show 2-3 sample vocabulary words
- Display a sample phrase with context
- Let users see the difficulty level

#### 3. Progress Visualization
- Show overall progress through the 20 courses
- Display estimated time to completion
- Highlight achievements and milestones

#### 4. Adaptive Learning
- Track user performance in each course
- Adjust difficulty for subsequent courses
- Provide additional practice for weak areas

#### 5. Content Variety
- Mix vocabulary, phrases, and grammar
- Include listening exercises (future)
- Add speaking practice (future)

## Success Metrics
- 80%+ users complete Course 1
- 60%+ users complete at least 5 courses
- 40%+ users complete all 20 courses in a sub-category
- 85%+ accuracy rate on course completion
- 4.5+ user satisfaction rating for AI-generated content
