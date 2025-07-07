# Level Selection Feature

This feature allows users to select their English proficiency level after signing in. The selected level is saved to Firestore and used to personalize content.

## Structure
- data/: Data sources, models, repository implementations
- domain/: Entities, repository interfaces, use cases
- presentation/: BLoC, pages, widgets

## Flow
1. User selects a level
2. Level is saved to Firestore
3. Used to tailor vocabulary/phrase difficulty 