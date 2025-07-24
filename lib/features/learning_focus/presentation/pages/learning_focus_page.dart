// learning_focus_page.dart
// Main page for learning focus selection.
//
// Usage Example:
//   Navigator.push(
//     context,
//     MaterialPageRoute(
//       builder: (_) => LearningFocusPage(userId: 'user123'),
//     ),
//   );
//
// This page allows users to select their learning focus preferences.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_english/core/dependency%20injection/locator.dart';
import 'package:learning_english/core/widgets/g_button.dart';
import 'package:learning_english/core/widgets/g_gap.dart';
import 'package:learning_english/core/widgets/g_scaffold.dart';
import 'package:learning_english/core/widgets/g_text.dart';
import '../bloc/learning_focus_bloc.dart';
import '../bloc/learning_focus_event.dart';
import '../bloc/learning_focus_state.dart';
import '../widgets/learning_focus_grid.dart';

class LearningFocusPage extends StatelessWidget {
  final String userId;

  const LearningFocusPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (_) =>
              getIt<LearningFocusBloc>()
                ..add(const LearningFocusEvent.loadOptions()),
      child: BlocConsumer<LearningFocusBloc, LearningFocusState>(
        listener: (context, state) {
          state.whenOrNull(
            success: () {
              // Navigate to next screen or show success message
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Learning focus preferences saved successfully!',
                  ),
                ),
              );
              // TODO: Navigate to next screen
              Navigator.pop(context);
            },
            error: (message) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(message)));
            },
          );
        },
        builder: (context, state) {
          return GScaffold(
            backgroundColor: const Color(0xFF1A1A1A),
            appBar: AppBar(
              backgroundColor: const Color(0xFF1A1A1A),
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              title: const GText(
                'برگشت',
                style: TextStyle(color: Colors.white),
              ),
              centerTitle: false,
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Center(
                            child: GText(
                              'Choose Your Learning Focus',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          GGap.v32,
                          state.when(
                            initial:
                                () => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                            loading:
                                () => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                            loaded:
                                (options) => LearningFocusGrid(
                                  options: options,
                                  onFocusSelected: (type) {
                                    context.read<LearningFocusBloc>().add(
                                      LearningFocusEvent.toggleSelection(type),
                                    );
                                  },
                                ),
                            error:
                                (message) => Center(
                                  child: Column(
                                    children: [
                                      GText(
                                        'Error: $message',
                                        style: const TextStyle(
                                          color: Colors.red,
                                        ),
                                      ),
                                      GGap.v16,
                                      GButton(
                                        onPressed: () {
                                          context.read<LearningFocusBloc>().add(
                                            const LearningFocusEvent.loadOptions(),
                                          );
                                        },
                                        text: 'Retry',
                                      ),
                                    ],
                                  ),
                                ),
                            success:
                                () => const Center(
                                  child: GText(
                                    'Success!',
                                    style: TextStyle(color: Colors.green),
                                  ),
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    child: state.maybeWhen(
                      loaded: (options) {
                        final hasSelections = options.any(
                          (option) => option.isSelected,
                        );
                        return GButton(
                          onPressed:
                              hasSelections
                                  ? () {
                                    context.read<LearningFocusBloc>().add(
                                      LearningFocusEvent.saveSelections(userId),
                                    );
                                  }
                                  : null,
                          text: 'Continue',
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFD700),
                            foregroundColor: Colors.black,
                            minimumSize: const Size(double.infinity, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                      },
                      orElse: () => const SizedBox.shrink(),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
