import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:learning_english/features/learning_focus_selection/presentation/bloc/learning_focus_selection_cubit.dart';
import 'package:learning_english/features/learning_focus_selection/domain/usecases/save_learning_focus_selection_usecase.dart';
import 'package:learning_english/features/learning_focus_selection/domain/usecases/get_learning_focus_selection_usecase.dart';
import 'package:learning_english/features/learning_focus_selection/domain/entities/learning_focus_selection.dart';

class MockSaveLearningFocusSelectionUseCase extends Mock
    implements SaveLearningFocusSelectionUseCase {}

class MockGetLearningFocusSelectionUseCase extends Mock
    implements GetLearningFocusSelectionUseCase {}

void main() {
  group('LearningFocusSelectionCubit', () {
    late LearningFocusSelectionCubit cubit;
    late MockSaveLearningFocusSelectionUseCase mockSaveUseCase;
    late MockGetLearningFocusSelectionUseCase mockGetUseCase;

    setUp(() {
      mockSaveUseCase = MockSaveLearningFocusSelectionUseCase();
      mockGetUseCase = MockGetLearningFocusSelectionUseCase();
      when(() => mockSaveUseCase(any())).thenAnswer((_) async {});
      when(
        () => mockGetUseCase(),
      ).thenAnswer((_) async => const LearningFocusSelection());
      cubit = LearningFocusSelectionCubit(
        saveUseCase: mockSaveUseCase,
        getUseCase: mockGetUseCase,
      );
    });

    test(
      'initial state is empty selection, empty custom text, and not saved',
      () {
        expect(cubit.state.selectedTexts, isEmpty);
        expect(cubit.state.customText, equals(''));
        expect(cubit.state.saveSuccess, isFalse);
      },
    );

    test('addText adds text to selection', () {
      cubit.addText('Business English');
      expect(cubit.state.selectedTexts, contains('Business English'));
    });

    test(
      'updateCustomText updates custom text without adding to selection',
      () {
        cubit.updateCustomText('Custom Learning Goal');
        expect(cubit.state.customText, equals('Custom Learning Goal'));
        expect(cubit.state.selectedTexts, isEmpty);
      },
    );

    test('removeText removes text from selection', () {
      cubit.addText('Business English');
      cubit.addText('Travel English');
      cubit.removeText('Business English');
      expect(cubit.state.selectedTexts, contains('Travel English'));
      expect(cubit.state.selectedTexts, isNot(contains('Business English')));
    });

    test('toggleText adds and removes text', () {
      cubit.toggleText('Business English');
      expect(cubit.state.selectedTexts, contains('Business English'));
      cubit.toggleText('Business English');
      expect(cubit.state.selectedTexts, isNot(contains('Business English')));
    });

    test('clearSelection clears all selections and custom text', () {
      cubit.addText('Business English');
      cubit.addText('Travel English');
      cubit.updateCustomText('Custom Goal');
      cubit.clearSelection();
      expect(cubit.state.selectedTexts, isEmpty);
      expect(cubit.state.customText, equals(''));
    });

    test('saveSelection calls use case and emits saveSuccess', () async {
      cubit.addText('Business English');
      cubit.addText('Travel English');
      await cubit.saveSelection();
      verify(() => mockSaveUseCase(any())).called(1);
      expect(cubit.state.saveSuccess, isTrue);
    });

    test('saveSelection includes custom text in saved data', () async {
      cubit.addText('Business English');
      cubit.updateCustomText('Custom Learning Goal');
      await cubit.saveSelection();

      // Verify that the use case was called with data including both selected texts and custom text
      verify(() => mockSaveUseCase(any())).called(1);
      expect(cubit.state.saveSuccess, isTrue);
    });

    test('saveSelection does not add empty custom text', () async {
      cubit.addText('Business English');
      cubit.updateCustomText('   '); // Empty after trim
      await cubit.saveSelection();

      verify(() => mockSaveUseCase(any())).called(1);
      expect(cubit.state.saveSuccess, isTrue);
    });

    test('isTextSelected returns correct boolean', () {
      cubit.addText('Business English');
      expect(cubit.isTextSelected('Business English'), isTrue);
      expect(cubit.isTextSelected('Travel English'), isFalse);
    });

    test('combinedContent returns joined texts', () {
      cubit.addText('Business English');
      cubit.addText('Travel English');
      expect(cubit.combinedContent, equals('Business English; Travel English'));
    });

    test('isEmpty and isNotEmpty work correctly with selected texts', () {
      expect(cubit.isEmpty, isTrue);
      expect(cubit.isNotEmpty, isFalse);

      cubit.addText('Business English');
      expect(cubit.isEmpty, isFalse);
      expect(cubit.isNotEmpty, isTrue);
    });

    test('isEmpty and isNotEmpty work correctly with custom text', () {
      expect(cubit.isEmpty, isTrue);
      expect(cubit.isNotEmpty, isFalse);

      cubit.updateCustomText('Custom Goal');
      expect(cubit.isEmpty, isFalse);
      expect(cubit.isNotEmpty, isTrue);
    });

    test(
      'isEmpty and isNotEmpty work correctly with both selected texts and custom text',
      () {
        expect(cubit.isEmpty, isTrue);
        expect(cubit.isNotEmpty, isFalse);

        cubit.addText('Business English');
        cubit.updateCustomText('Custom Goal');
        expect(cubit.isEmpty, isFalse);
        expect(cubit.isNotEmpty, isTrue);
      },
    );

    test('isEmpty returns true for empty custom text with spaces', () {
      cubit.updateCustomText('   ');
      expect(cubit.isEmpty, isTrue);
      expect(cubit.isNotEmpty, isFalse);
    });
  });
}
