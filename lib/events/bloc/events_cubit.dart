import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:event_app/model/event_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// Enum to represent different states
enum EventsStateEnum {
  initial,
  loading,
  loaded,
  error,
}

// Define the state for the EventsCubit
class EventsState extends Equatable {
  final EventsStateEnum state;
  final List<Event>? eventList;
  final String? error;

  const EventsState({
    required this.state,
    this.eventList,
    this.error,
  });

  @override
  List<Object?> get props => [state, eventList, error];
}

// Define the events for the EventsCubit
abstract class EventsEvent extends Equatable {
  const EventsEvent();

  @override
  List<Object?> get props => [];
}

class FetchEventsEvent extends EventsEvent {}

// Define the EventsCubit
class EventsCubit extends Cubit<EventsState> {
  EventsCubit() : super(EventsState(state: EventsStateEnum.initial)) {
    fetchEvents();
  }

  Future<void> fetchEvents() async {
    emit(EventsState(state: EventsStateEnum.loading));

    try {
      final List<Event> eventList = await _getDataFromApi();
      emit(EventsState(state: EventsStateEnum.loaded, eventList: eventList));
    } catch (e) {
      emit(EventsState(
          state: EventsStateEnum.error, error: 'Failed to load data'));
    }
  }

  Future<List<Event>> _getDataFromApi() async {
    final response = await http.get(Uri.parse(
        'https://sde-007.api.assignment.theinternetfolks.works/v1/event'));

    if (response.statusCode == 200) {
      // final List<dynamic> data = json.decode(response.body);
      final Map<String, dynamic> json = jsonDecode(response.body);

      final List<dynamic> eventData = json['content']['data'];
      final events =
          eventData.map((eventJson) => Event.fromJson(eventJson)).toList();

      return events;
    } else {
      throw Exception('Failed to load data');
    }
  }
}
