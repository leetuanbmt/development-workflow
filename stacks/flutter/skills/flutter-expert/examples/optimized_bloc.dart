import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

part 'optimized_bloc.freezed.dart';

// 1. Unified State with Status Enum
enum Status { initial, loading, success, failure }

@freezed
class OptimizedState with _$OptimizedState {
  const factory OptimizedState({
    @Default(Status.initial) Status status,
    @Default([]) List<String> items,
    String? errorMessage,
  }) = _OptimizedState;
}

// 2. Event Union
@freezed
class OptimizedEvent with _$OptimizedEvent {
  const factory OptimizedEvent.started() = _Started;
  const factory OptimizedEvent.search(String query) = _Search;
  const factory OptimizedEvent.refresh() = _Refresh;
}

class OptimizedBloc extends Bloc<OptimizedEvent, OptimizedState> {
  final Repository _repository;

  OptimizedBloc(this._repository) : super(const OptimizedState()) {
    on<OptimizedEvent>(
      (event, emit) async {
        await event.when(
          started: () => _onStarted(emit),
          search: (query) => _onSearch(query, emit),
          refresh: () => _onRefresh(emit),
        );
      },
      // 3. Transformer Optimization
      // Droppable: Ignore events if processing (Good for Refresh)
      // Restartable: Cancel previous if new event comes (Good for Search)
      transformer: (events, mapper) {
        return events.droppable().concurrent(); // Example custom strat
      },
    );
  }

  // 4. Efficient State Update
  Future<void> _onSearch(String query, Emitter<OptimizedState> emit) async {
    // Only emit loading if not already loading to avoid rebuilds
    if (state.status != Status.loading) {
      emit(state.copyWith(status: Status.loading));
    }

    try {
      final results = await _repository.search(query);
      emit(state.copyWith(
        status: Status.success,
        items: results,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: Status.failure,
        errorMessage: e.toString(),
      ));
    }
  }

  _onStarted(Emitter<OptimizedState> emit) {}
  _onRefresh(Emitter<OptimizedState> emit) {}
}

class Repository {
  Future<List<String>> search(String query) async => [];
}
