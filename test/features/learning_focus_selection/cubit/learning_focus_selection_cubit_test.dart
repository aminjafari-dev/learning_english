import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:learning_english/features/learning_focus_selection/presentation/bloc/learning_focus_selection_cubit.dart';
import 'package:learning_english/features/learning_focus_selection/domain/usecases/save_learning_focus_selection_usecase.dart';

class MockSaveLearningFocusSelectionUseCase extends Mock
    implements SaveLearningFocusSelectionUseCase {}

void main() {
  group('LearningFocusSelectionCubit', () {
    late LearningFocusSelectionCubit cubit;
    late MockSaveLearningFocusSelectionUseCase mockSaveUseCase;

    setUp(() {
      mockSaveUseCase = MockSaveLearningFocusSelectionUseCase();
      when(() => mockSaveUseCase(any())).thenAnswer((_) async {});
      cubit = LearningFocusSelectionCubit(mockSaveUseCase);
    });

    test('initial state is empty selection and not saved', () {
      expect(cubit.state.selectedIndices, isEmpty);
      expect(cubit.state.saveSuccess, isFalse);
    });

    test('toggleSelection adds and removes index', () {
      cubit.toggleSelection(1);
      expect(cubit.state.selectedIndices, contains(1));
      cubit.toggleSelection(1);
      expect(cubit.state.selectedIndices, isNot(contains(1)));
    });

    test('clearSelection clears all selections', () {
      cubit.toggleSelection(1);
      cubit.toggleSelection(2);
      cubit.clearSelection();
      expect(cubit.state.selectedIndices, isEmpty);
    });

    test('saveSelection calls use case and emits saveSuccess', () async {
      cubit.toggleSelection(2);
      await cubit.saveSelection();
      verify(() => mockSaveUseCase([2])).called(1);
      expect(cubit.state.saveSuccess, isTrue);
    });
  });
}
