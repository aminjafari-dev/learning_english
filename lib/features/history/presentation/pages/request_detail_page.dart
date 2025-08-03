import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:learning_english/core/dependency%20injection/locator.dart';
import 'package:learning_english/core/widgets/global_widget/g_scaffold.dart';
import 'package:learning_english/core/widgets/global_widget/g_text.dart';
import 'package:learning_english/core/theme/app_theme.dart';
import '../bloc/vocabulary_history_bloc.dart';
import '../bloc/vocabulary_history_event.dart';
import '../bloc/vocabulary_history_state.dart';
import '../widgets/request_detail_content.dart';

/// Detail page for displaying vocabulary and phrases for a specific request
/// This page shows all the vocabulary and phrase items that were generated
/// for a specific learning request
///
/// Usage Example:
///   Navigator.of(context).pushNamed(
///     PageName.requestDetails,
///     arguments: requestId,
///   );
///
/// This page follows the app's design patterns and uses the established
/// color scheme and UI components.
class RequestDetailPage extends StatelessWidget {
  final String requestId;

  const RequestDetailPage({super.key, required this.requestId});

  @override
  Widget build(BuildContext context) {
    // Use getIt for dependency injection instead of BlocProvider in the UI
    final bloc =
        getIt<VocabularyHistoryBloc>()..add(
          VocabularyHistoryEvent.loadRequestDetails(requestId: requestId),
        );

    return GScaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.background,
        elevation: 0,
        title: GText(
          AppLocalizations.of(context)!.requestDetails,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back_ios_new_rounded, size: 24),
        ),
        centerTitle: true,
      ),
      backgroundColor: AppTheme.background,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: BlocBuilder<VocabularyHistoryBloc, VocabularyHistoryState>(
          bloc: bloc,
          builder: (context, state) {
            return RequestDetailContent(state: state);
          },
        ),
      ),
    );
  }
}

// Example usage:
// Navigator.of(context).pushNamed(PageName.requestDetails, arguments: requestId);
