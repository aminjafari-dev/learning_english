import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_english/core/usecase/usecase.dart';
import 'package:learning_english/features/localization/domain/entities/locale_entity.dart';
import 'package:learning_english/features/localization/domain/usecases/get_current_locale_usecase.dart';
import 'package:learning_english/features/localization/domain/usecases/get_supported_locales_usecase.dart';
import 'package:learning_english/features/localization/domain/usecases/set_locale_usecase.dart';
import 'package:learning_english/features/localization/presentation/bloc/localization_event.dart';
import 'package:learning_english/features/localization/presentation/bloc/localization_state.dart';

/// BLoC for managing localization state
///
/// This BLoC handles all localization-related operations including loading
/// the current locale, setting a new locale, and getting supported locales.
/// It follows the BLoC pattern with proper state management and error handling.
///
/// Usage Example:
///   BlocProvider(
///     create: (context) => LocalizationBloc(
///       getCurrentLocaleUseCase: getIt<GetCurrentLocaleUseCase>(),
///       setLocaleUseCase: getIt<SetLocaleUseCase>(),
///       getSupportedLocalesUseCase: getIt<GetSupportedLocalesUseCase>(),
///     ),
///     child: MyWidget(),
///   );
class LocalizationBloc extends Bloc<LocalizationEvent, LocalizationState> {
  /// Use case for getting current locale
  final GetCurrentLocaleUseCase _getCurrentLocaleUseCase;

  /// Use case for setting locale
  final SetLocaleUseCase _setLocaleUseCase;

  /// Use case for getting supported locales
  final GetSupportedLocalesUseCase _getSupportedLocalesUseCase;

  /// Constructor for LocalizationBloc
  ///
  /// Parameters:
  ///   - getCurrentLocaleUseCase: Use case for getting current locale
  ///   - setLocaleUseCase: Use case for setting locale
  ///   - getSupportedLocalesUseCase: Use case for getting supported locales
  LocalizationBloc({
    required GetCurrentLocaleUseCase getCurrentLocaleUseCase,
    required SetLocaleUseCase setLocaleUseCase,
    required GetSupportedLocalesUseCase getSupportedLocalesUseCase,
  }) : _getCurrentLocaleUseCase = getCurrentLocaleUseCase,
       _setLocaleUseCase = setLocaleUseCase,
       _getSupportedLocalesUseCase = getSupportedLocalesUseCase,
       super(
         const LocalizationState(
           loadCurrentLocale: LoadCurrentLocaleState.initial(),
           setLocale: SetLocaleState.initial(),
           getSupportedLocales: GetSupportedLocalesState.initial(),
         ),
       ) {
    on<LocalizationEvent>(_onEvent);
  }

  /// Handles all localization events
  ///
  /// This method processes all events using pattern matching and delegates
  /// to specific event handlers. It follows the BLoC pattern with async
  /// event handling and proper error management.
  ///
  /// Parameters:
  ///   - event: The event to handle
  ///   - emit: Function to emit new states
  Future<void> _onEvent(
    LocalizationEvent event,
    Emitter<LocalizationState> emit,
  ) async {
    await event.when(
      loadCurrentLocale: () async => await _onLoadCurrentLocale(emit),
      setLocale: (locale) async => await _onSetLocale(locale, emit),
      getSupportedLocales: () async => await _onGetSupportedLocales(emit),
      reset: () async => await _onReset(emit),
    );
  }

  /// Handles loading current locale
  ///
  /// This method calls the use case to get the current locale and emits
  /// appropriate states based on the result. It includes safety checks
  /// to prevent emit after completion errors.
  ///
  /// Parameters:
  ///   - emit: Function to emit new states
  Future<void> _onLoadCurrentLocale(Emitter<LocalizationState> emit) async {
    // Emit loading state
    if (!emit.isDone) {
      emit(
        state.copyWith(
          loadCurrentLocale: const LoadCurrentLocaleState.loading(),
        ),
      );
    }

    // Call the use case
    final result = await _getCurrentLocaleUseCase(NoParams());

    // Handle the result
    result.fold(
      (failure) {
        if (!emit.isDone) {
          emit(
            state.copyWith(
              loadCurrentLocale: LoadCurrentLocaleState.error(failure.message),
            ),
          );
        }
      },
      (locale) {
        if (!emit.isDone) {
          emit(
            state.copyWith(
              loadCurrentLocale: LoadCurrentLocaleState.completed(locale),
            ),
          );
        }
      },
    );
  }

  /// Handles setting locale
  ///
  /// This method calls the use case to set the locale and emits
  /// appropriate states based on the result. It includes safety checks
  /// to prevent emit after completion errors.
  ///
  /// Parameters:
  ///   - locale: The locale to set
  ///   - emit: Function to emit new states
  Future<void> _onSetLocale(
    LocaleEntity locale,
    Emitter<LocalizationState> emit,
  ) async {
    // Emit loading state
    if (!emit.isDone) {
      emit(state.copyWith(setLocale: const SetLocaleState.loading()));
    }

    // Call the use case
    final result = await _setLocaleUseCase(SetLocaleParams(locale: locale));

    // Handle the result
    result.fold(
      (failure) {
        if (!emit.isDone) {
          emit(
            state.copyWith(setLocale: SetLocaleState.error(failure.message)),
          );
        }
      },
      (setLocale) {
        if (!emit.isDone) {
          // Update both setLocale and loadCurrentLocale states
          emit(
            state.copyWith(
              setLocale: SetLocaleState.completed(setLocale),
              loadCurrentLocale: LoadCurrentLocaleState.completed(setLocale),
            ),
          );
        }
      },
    );
  }

  /// Handles getting supported locales
  ///
  /// This method calls the use case to get supported locales and emits
  /// appropriate states based on the result. It includes safety checks
  /// to prevent emit after completion errors.
  ///
  /// Parameters:
  ///   - emit: Function to emit new states
  Future<void> _onGetSupportedLocales(Emitter<LocalizationState> emit) async {
    // Emit loading state
    if (!emit.isDone) {
      emit(
        state.copyWith(
          getSupportedLocales: const GetSupportedLocalesState.loading(),
        ),
      );
    }

    // Call the use case
    final result = await _getSupportedLocalesUseCase(NoParams());

    // Handle the result
    result.fold(
      (failure) {
        if (!emit.isDone) {
          emit(
            state.copyWith(
              getSupportedLocales: GetSupportedLocalesState.error(
                failure.message,
              ),
            ),
          );
        }
      },
      (locales) {
        if (!emit.isDone) {
          emit(
            state.copyWith(
              getSupportedLocales: GetSupportedLocalesState.completed(locales),
            ),
          );
        }
      },
    );
  }

  /// Handles resetting localization state
  ///
  /// This method resets all localization states to their initial values.
  /// It includes safety checks to prevent emit after completion errors.
  ///
  /// Parameters:
  ///   - emit: Function to emit new states
  Future<void> _onReset(Emitter<LocalizationState> emit) async {
    if (!emit.isDone) {
      emit(
        const LocalizationState(
          loadCurrentLocale: LoadCurrentLocaleState.initial(),
          setLocale: SetLocaleState.initial(),
          getSupportedLocales: GetSupportedLocalesState.initial(),
        ),
      );
    }
  }
}
