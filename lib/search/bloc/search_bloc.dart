// search_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:event_app/model/event_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Event
abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class PerformSearch extends SearchEvent {
  final String query;

  PerformSearch(this.query);

  @override
  List<Object?> get props => [query];
}

// State
enum SearchStateEnum {
  initial,
  loading,
  loaded,
  error,
}

class SearchState extends Equatable {
  final SearchStateEnum state;
  final List<Event>? searchResults;
  final String? error;

  const SearchState({
    required this.state,
    this.searchResults,
    this.error,
  });

  @override
  List<Object?> get props => [state, searchResults, error];
}

// Bloc
class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchState(state: SearchStateEnum.initial)) {
    on<PerformSearch>(_performSearch);
  }

  void _performSearch(PerformSearch event, Emitter<SearchState> emit) async {
    emit(SearchState(state: SearchStateEnum.loading));

    try {
      final List<Event> results = await _fetchSearchResults(event.query);
      emit(SearchState(state: SearchStateEnum.loaded, searchResults: results));
    } catch (e) {
      emit(SearchState(
          state: SearchStateEnum.error, error: 'Failed to fetch data'));
    }
  }
}

Future<List<Event>> _fetchSearchResults(String query) async {
  final response = await http.get(Uri.parse(
      'https://sde-007.api.assignment.theinternetfolks.works/v1/event?search=$query'));

  if (response.statusCode == 200) {
    final Map<String, dynamic> json = jsonDecode(response.body);

    final List<dynamic> eventData = json['content']['data'];
    final events =
        eventData.map((eventJson) => Event.fromJson(eventJson)).toList();

    return events;
  } else {
    throw Exception('Failed to load data');
  }
}
