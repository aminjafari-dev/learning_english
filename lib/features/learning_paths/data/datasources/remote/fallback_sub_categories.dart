// fallback_sub_categories.dart
// Pre-defined sub-categories for each level + focus combination
// Used when AI generation fails or is unavailable

import '../../models/sub_category_model.dart';
import '../../../../level_selection/domain/entities/user_profile.dart';

/// Fallback sub-categories when AI generation fails
class FallbackSubCategories {
  /// Gets fallback sub-categories based on level and focus areas
  static List<SubCategoryModel> getSubCategories({
    required Level level,
    required List<String> focusAreas,
  }) {
    // Get the primary focus area (first one)
    final primaryFocus =
        focusAreas.isNotEmpty ? focusAreas.first.toLowerCase() : 'general';

    switch (primaryFocus) {
      case 'business':
        return _getBusinessSubCategories(level);
      case 'travel':
        return _getTravelSubCategories(level);
      case 'social':
        return _getSocialSubCategories(level);
      case 'academic':
        return _getAcademicSubCategories(level);
      case 'technology':
        return _getTechnologySubCategories(level);
      case 'health':
        return _getHealthSubCategories(level);
      default:
        return _getGeneralSubCategories(level);
    }
  }

  /// Business-focused sub-categories
  static List<SubCategoryModel> _getBusinessSubCategories(Level level) {
    switch (level) {
      case Level.beginner:
        return [
          SubCategoryModel(
            id: 'business_basics_beginner',
            title: 'Business Basics',
            description:
                'Learn essential business vocabulary and simple workplace conversations',
            difficulty: 'beginner',
            estimatedLessons: 20,
            keyTopics: [
              'office vocabulary',
              'simple meetings',
              'email basics',
              'introductions',
            ],
          ),
          SubCategoryModel(
            id: 'customer_service_beginner',
            title: 'Customer Service',
            description:
                'Handle basic customer interactions and service situations',
            difficulty: 'beginner',
            estimatedLessons: 20,
            keyTopics: [
              'greeting customers',
              'taking orders',
              'handling complaints',
              'payment',
            ],
          ),
        ];
      case Level.elementary:
        return [
          SubCategoryModel(
            id: 'meetings_elementary',
            title: 'Meetings & Discussions',
            description:
                'Participate in simple business meetings and discussions',
            difficulty: 'elementary',
            estimatedLessons: 20,
            keyTopics: [
              'meeting preparation',
              'expressing opinions',
              'asking questions',
              'summarizing',
            ],
          ),
          SubCategoryModel(
            id: 'email_writing_elementary',
            title: 'Email Communication',
            description: 'Write clear and professional business emails',
            difficulty: 'elementary',
            estimatedLessons: 20,
            keyTopics: [
              'email structure',
              'formal language',
              'requests',
              'follow-ups',
            ],
          ),
        ];
      case Level.intermediate:
        return [
          SubCategoryModel(
            id: 'meetings_intermediate',
            title: 'Meetings & Discussions',
            description:
                'Master professional meeting vocabulary, phrases for leading discussions, and expressing opinions in business settings',
            difficulty: 'intermediate',
            estimatedLessons: 20,
            keyTopics: [
              'meeting preparation',
              'leading discussions',
              'expressing opinions',
              'handling disagreements',
            ],
          ),
          SubCategoryModel(
            id: 'negotiations_intermediate',
            title: 'Negotiations & Deals',
            description:
                'Learn negotiation tactics, deal-making vocabulary, and persuasive language for business negotiations',
            difficulty: 'intermediate',
            estimatedLessons: 20,
            keyTopics: [
              'negotiation strategies',
              'persuasive language',
              'deal closing',
              'compromise solutions',
            ],
          ),
          SubCategoryModel(
            id: 'email_writing_intermediate',
            title: 'Professional Email Writing',
            description:
                'Write effective business emails, from formal requests to follow-ups and professional correspondence',
            difficulty: 'intermediate',
            estimatedLessons: 20,
            keyTopics: [
              'email structure',
              'formal tone',
              'follow-up emails',
              'email etiquette',
            ],
          ),
          SubCategoryModel(
            id: 'presentations_intermediate',
            title: 'Presentations & Public Speaking',
            description:
                'Deliver confident presentations, handle Q&A sessions, and use visual aids effectively in business settings',
            difficulty: 'intermediate',
            estimatedLessons: 20,
            keyTopics: [
              'presentation structure',
              'visual aids',
              'Q&A handling',
              'confidence building',
            ],
          ),
        ];
      case Level.advanced:
        return [
          SubCategoryModel(
            id: 'strategic_planning_advanced',
            title: 'Strategic Planning',
            description:
                'Advanced business strategy vocabulary and complex planning discussions',
            difficulty: 'advanced',
            estimatedLessons: 20,
            keyTopics: [
              'strategic analysis',
              'market research',
              'competitive advantage',
              'implementation',
            ],
          ),
          SubCategoryModel(
            id: 'leadership_advanced',
            title: 'Leadership & Management',
            description:
                'Advanced leadership concepts, team management, and organizational development',
            difficulty: 'advanced',
            estimatedLessons: 20,
            keyTopics: [
              'team leadership',
              'change management',
              'performance evaluation',
              'organizational culture',
            ],
          ),
        ];
    }
  }

  /// Travel-focused sub-categories
  static List<SubCategoryModel> _getTravelSubCategories(Level level) {
    switch (level) {
      case Level.beginner:
        return [
          SubCategoryModel(
            id: 'airport_basics_beginner',
            title: 'Airport & Transportation',
            description:
                'Essential vocabulary for navigating airports, booking tickets, and using public transportation',
            difficulty: 'beginner',
            estimatedLessons: 20,
            keyTopics: [
              'check-in process',
              'boarding passes',
              'baggage claim',
              'public transport',
            ],
          ),
          SubCategoryModel(
            id: 'hotel_accommodation_beginner',
            title: 'Hotels & Accommodation',
            description:
                'Book rooms, check in/out, request services, and handle common hotel situations',
            difficulty: 'beginner',
            estimatedLessons: 20,
            keyTopics: [
              'room booking',
              'check-in process',
              'hotel services',
              'complaints',
            ],
          ),
          SubCategoryModel(
            id: 'restaurant_dining_beginner',
            title: 'Restaurants & Dining',
            description:
                'Order food, ask about ingredients, pay bills, and handle dining situations confidently',
            difficulty: 'beginner',
            estimatedLessons: 20,
            keyTopics: [
              'menu reading',
              'ordering food',
              'dietary restrictions',
              'paying bills',
            ],
          ),
          SubCategoryModel(
            id: 'shopping_basics_beginner',
            title: 'Shopping & Souvenirs',
            description:
                'Shop for essentials, ask for help, compare prices, and buy souvenirs',
            difficulty: 'beginner',
            estimatedLessons: 20,
            keyTopics: [
              'asking for help',
              'price comparison',
              'sizes and colors',
              'payment methods',
            ],
          ),
        ];
      case Level.elementary:
        return [
          SubCategoryModel(
            id: 'travel_planning_elementary',
            title: 'Travel Planning',
            description:
                'Plan trips, book accommodations, and organize travel itineraries',
            difficulty: 'elementary',
            estimatedLessons: 20,
            keyTopics: [
              'trip planning',
              'booking systems',
              'itinerary creation',
              'travel insurance',
            ],
          ),
          SubCategoryModel(
            id: 'cultural_experiences_elementary',
            title: 'Cultural Experiences',
            description:
                'Engage with local culture, visit attractions, and participate in cultural activities',
            difficulty: 'elementary',
            estimatedLessons: 20,
            keyTopics: [
              'museum visits',
              'cultural sites',
              'local customs',
              'festivals',
            ],
          ),
        ];
      case Level.intermediate:
        return [
          SubCategoryModel(
            id: 'travel_negotiations_intermediate',
            title: 'Travel Negotiations',
            description:
                'Negotiate prices, handle travel disputes, and manage complex travel situations',
            difficulty: 'intermediate',
            estimatedLessons: 20,
            keyTopics: [
              'price negotiation',
              'dispute resolution',
              'travel insurance claims',
              'refund requests',
            ],
          ),
          SubCategoryModel(
            id: 'local_interactions_intermediate',
            title: 'Local Interactions',
            description:
                'Engage with locals, understand cultural nuances, and build meaningful connections',
            difficulty: 'intermediate',
            estimatedLessons: 20,
            keyTopics: [
              'cultural sensitivity',
              'local customs',
              'making friends',
              'community engagement',
            ],
          ),
        ];
      case Level.advanced:
        return [
          SubCategoryModel(
            id: 'travel_blogging_advanced',
            title: 'Travel Writing & Blogging',
            description:
                'Write compelling travel content, reviews, and share experiences effectively',
            difficulty: 'advanced',
            estimatedLessons: 20,
            keyTopics: [
              'travel writing',
              'review writing',
              'social media content',
              'storytelling',
            ],
          ),
        ];
    }
  }

  /// Social-focused sub-categories
  static List<SubCategoryModel> _getSocialSubCategories(Level level) {
    switch (level) {
      case Level.beginner:
        return [
          SubCategoryModel(
            id: 'daily_conversations_beginner',
            title: 'Daily Conversations',
            description: 'Basic everyday conversations and social interactions',
            difficulty: 'beginner',
            estimatedLessons: 20,
            keyTopics: [
              'greetings',
              'small talk',
              'asking for help',
              'expressing needs',
            ],
          ),
          SubCategoryModel(
            id: 'family_friends_beginner',
            title: 'Family & Friends',
            description:
                'Talk about family, friends, and personal relationships',
            difficulty: 'beginner',
            estimatedLessons: 20,
            keyTopics: [
              'family members',
              'describing people',
              'relationships',
              'personal information',
            ],
          ),
        ];
      case Level.elementary:
        return [
          SubCategoryModel(
            id: 'hobbies_interests_elementary',
            title: 'Hobbies & Interests',
            description: 'Discuss hobbies, interests, and leisure activities',
            difficulty: 'elementary',
            estimatedLessons: 20,
            keyTopics: ['sports', 'music', 'movies', 'reading', 'cooking'],
          ),
          SubCategoryModel(
            id: 'social_events_elementary',
            title: 'Social Events',
            description:
                'Navigate parties, celebrations, and social gatherings',
            difficulty: 'elementary',
            estimatedLessons: 20,
            keyTopics: [
              'party conversations',
              'celebrations',
              'invitations',
              'social etiquette',
            ],
          ),
        ];
      case Level.intermediate:
        return [
          SubCategoryModel(
            id: 'relationships_intermediate',
            title: 'Relationships & Dating',
            description:
                'Discuss relationships, dating, and emotional connections',
            difficulty: 'intermediate',
            estimatedLessons: 20,
            keyTopics: [
              'dating vocabulary',
              'relationship advice',
              'emotional expressions',
              'conflict resolution',
            ],
          ),
          SubCategoryModel(
            id: 'social_media_intermediate',
            title: 'Social Media & Digital Communication',
            description:
                'Navigate social media, online communities, and digital social interactions',
            difficulty: 'intermediate',
            estimatedLessons: 20,
            keyTopics: [
              'social media language',
              'online etiquette',
              'digital communication',
              'virtual relationships',
            ],
          ),
        ];
      case Level.advanced:
        return [
          SubCategoryModel(
            id: 'philosophy_advanced',
            title: 'Philosophy & Deep Conversations',
            description:
                'Engage in philosophical discussions and deep, meaningful conversations',
            difficulty: 'advanced',
            estimatedLessons: 20,
            keyTopics: [
              'philosophical concepts',
              'ethical discussions',
              'abstract thinking',
              'intellectual debates',
            ],
          ),
        ];
    }
  }

  /// Academic-focused sub-categories
  static List<SubCategoryModel> _getAcademicSubCategories(Level level) {
    switch (level) {
      case Level.beginner:
        return [
          SubCategoryModel(
            id: 'classroom_basics_beginner',
            title: 'Classroom Basics',
            description:
                'Essential vocabulary for classroom interactions and basic academic communication',
            difficulty: 'beginner',
            estimatedLessons: 20,
            keyTopics: [
              'classroom objects',
              'basic instructions',
              'asking questions',
              'homework',
            ],
          ),
        ];
      case Level.elementary:
        return [
          SubCategoryModel(
            id: 'study_skills_elementary',
            title: 'Study Skills',
            description:
                'Learn effective study techniques and academic vocabulary',
            difficulty: 'elementary',
            estimatedLessons: 20,
            keyTopics: [
              'note-taking',
              'research methods',
              'time management',
              'exam preparation',
            ],
          ),
        ];
      case Level.intermediate:
        return [
          SubCategoryModel(
            id: 'academic_writing_intermediate',
            title: 'Academic Writing',
            description:
                'Write essays, reports, and academic papers with proper structure and vocabulary',
            difficulty: 'intermediate',
            estimatedLessons: 20,
            keyTopics: [
              'essay structure',
              'research papers',
              'citations',
              'academic vocabulary',
            ],
          ),
          SubCategoryModel(
            id: 'presentations_intermediate',
            title: 'Academic Presentations',
            description:
                'Deliver academic presentations and participate in scholarly discussions',
            difficulty: 'intermediate',
            estimatedLessons: 20,
            keyTopics: [
              'presentation skills',
              'research presentation',
              'academic discussions',
              'peer review',
            ],
          ),
        ];
      case Level.advanced:
        return [
          SubCategoryModel(
            id: 'research_advanced',
            title: 'Research & Analysis',
            description:
                'Advanced research methodologies, data analysis, and scholarly communication',
            difficulty: 'advanced',
            estimatedLessons: 20,
            keyTopics: [
              'research methodology',
              'data analysis',
              'scholarly writing',
              'peer review',
            ],
          ),
        ];
    }
  }

  /// Technology-focused sub-categories
  static List<SubCategoryModel> _getTechnologySubCategories(Level level) {
    switch (level) {
      case Level.beginner:
        return [
          SubCategoryModel(
            id: 'basic_computing_beginner',
            title: 'Basic Computing',
            description:
                'Essential computer and internet vocabulary for beginners',
            difficulty: 'beginner',
            estimatedLessons: 20,
            keyTopics: [
              'computer parts',
              'basic software',
              'internet basics',
              'email',
            ],
          ),
        ];
      case Level.elementary:
        return [
          SubCategoryModel(
            id: 'social_media_elementary',
            title: 'Social Media & Apps',
            description:
                'Navigate social media platforms and mobile applications',
            difficulty: 'elementary',
            estimatedLessons: 20,
            keyTopics: [
              'social platforms',
              'app usage',
              'online safety',
              'digital communication',
            ],
          ),
        ];
      case Level.intermediate:
        return [
          SubCategoryModel(
            id: 'programming_intermediate',
            title: 'Programming & Development',
            description:
                'Learn programming concepts, software development, and technical communication',
            difficulty: 'intermediate',
            estimatedLessons: 20,
            keyTopics: [
              'programming languages',
              'software development',
              'technical documentation',
              'debugging',
            ],
          ),
          SubCategoryModel(
            id: 'cybersecurity_intermediate',
            title: 'Cybersecurity & Privacy',
            description:
                'Understand cybersecurity concepts, privacy protection, and digital safety',
            difficulty: 'intermediate',
            estimatedLessons: 20,
            keyTopics: [
              'online security',
              'privacy protection',
              'cyber threats',
              'safe practices',
            ],
          ),
        ];
      case Level.advanced:
        return [
          SubCategoryModel(
            id: 'ai_ml_advanced',
            title: 'AI & Machine Learning',
            description:
                'Advanced concepts in artificial intelligence, machine learning, and emerging technologies',
            difficulty: 'advanced',
            estimatedLessons: 20,
            keyTopics: [
              'artificial intelligence',
              'machine learning',
              'neural networks',
              'future technology',
            ],
          ),
        ];
    }
  }

  /// Health-focused sub-categories
  static List<SubCategoryModel> _getHealthSubCategories(Level level) {
    switch (level) {
      case Level.beginner:
        return [
          SubCategoryModel(
            id: 'basic_health_beginner',
            title: 'Basic Health',
            description:
                'Essential health vocabulary and basic medical conversations',
            difficulty: 'beginner',
            estimatedLessons: 20,
            keyTopics: [
              'body parts',
              'common illnesses',
              'doctor visits',
              'medications',
            ],
          ),
        ];
      case Level.elementary:
        return [
          SubCategoryModel(
            id: 'fitness_nutrition_elementary',
            title: 'Fitness & Nutrition',
            description: 'Discuss fitness, exercise, and healthy eating habits',
            difficulty: 'elementary',
            estimatedLessons: 20,
            keyTopics: [
              'exercise routines',
              'healthy eating',
              'fitness goals',
              'wellness',
            ],
          ),
        ];
      case Level.intermediate:
        return [
          SubCategoryModel(
            id: 'mental_health_intermediate',
            title: 'Mental Health & Wellness',
            description:
                'Discuss mental health, stress management, and emotional well-being',
            difficulty: 'intermediate',
            estimatedLessons: 20,
            keyTopics: [
              'stress management',
              'emotional health',
              'therapy',
              'mindfulness',
            ],
          ),
        ];
      case Level.advanced:
        return [
          SubCategoryModel(
            id: 'medical_professional_advanced',
            title: 'Medical & Healthcare',
            description:
                'Advanced medical terminology and healthcare professional communication',
            difficulty: 'advanced',
            estimatedLessons: 20,
            keyTopics: [
              'medical terminology',
              'patient care',
              'diagnosis',
              'treatment plans',
            ],
          ),
        ];
    }
  }

  /// General sub-categories for any focus area
  static List<SubCategoryModel> _getGeneralSubCategories(Level level) {
    switch (level) {
      case Level.beginner:
        return [
          SubCategoryModel(
            id: 'daily_life_beginner',
            title: 'Daily Life',
            description:
                'Essential vocabulary for everyday situations and basic communication',
            difficulty: 'beginner',
            estimatedLessons: 20,
            keyTopics: [
              'daily routines',
              'shopping',
              'transportation',
              'time expressions',
            ],
          ),
          SubCategoryModel(
            id: 'basic_grammar_beginner',
            title: 'Basic Grammar',
            description:
                'Learn fundamental grammar structures and sentence patterns',
            difficulty: 'beginner',
            estimatedLessons: 20,
            keyTopics: [
              'present tense',
              'basic questions',
              'negatives',
              'simple sentences',
            ],
          ),
        ];
      case Level.elementary:
        return [
          SubCategoryModel(
            id: 'conversation_elementary',
            title: 'Conversation Skills',
            description:
                'Improve conversational English and social communication',
            difficulty: 'elementary',
            estimatedLessons: 20,
            keyTopics: [
              'small talk',
              'asking questions',
              'giving opinions',
              'active listening',
            ],
          ),
          SubCategoryModel(
            id: 'vocabulary_building_elementary',
            title: 'Vocabulary Building',
            description: 'Expand vocabulary with common words and phrases',
            difficulty: 'elementary',
            estimatedLessons: 20,
            keyTopics: [
              'word families',
              'synonyms',
              'antonyms',
              'context clues',
            ],
          ),
        ];
      case Level.intermediate:
        return [
          SubCategoryModel(
            id: 'fluency_intermediate',
            title: 'Fluency & Expression',
            description: 'Develop fluency and natural expression in English',
            difficulty: 'intermediate',
            estimatedLessons: 20,
            keyTopics: [
              'natural speech',
              'idioms',
              'phrasal verbs',
              'collocations',
            ],
          ),
          SubCategoryModel(
            id: 'critical_thinking_intermediate',
            title: 'Critical Thinking',
            description:
                'Express opinions, analyze information, and engage in thoughtful discussions',
            difficulty: 'intermediate',
            estimatedLessons: 20,
            keyTopics: [
              'opinion expression',
              'argumentation',
              'analysis',
              'evaluation',
            ],
          ),
        ];
      case Level.advanced:
        return [
          SubCategoryModel(
            id: 'mastery_advanced',
            title: 'Language Mastery',
            description:
                'Achieve advanced proficiency with complex language structures and nuanced communication',
            difficulty: 'advanced',
            estimatedLessons: 20,
            keyTopics: [
              'complex grammar',
              'nuanced vocabulary',
              'cultural references',
              'sophisticated expression',
            ],
          ),
        ];
    }
  }
}
