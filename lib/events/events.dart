import 'package:event_app/event_details/event_details.dart';
import 'package:event_app/events/bloc/events_cubit.dart';
import 'package:event_app/model/event_model.dart';
import 'package:event_app/search/search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../util/dateTime.dart';

class Events extends StatefulWidget {
  const Events({super.key});

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {
  late EventsCubit eventsCubit;

  @override
  void initState() {
    super.initState();
    eventsCubit = EventsCubit();
    eventsCubit.fetchEvents();
  }

  @override
  void dispose() {
    eventsCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => eventsCubit,
      child: Scaffold(
          appBar: AppBar(
            title: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                "Events",
                style: TextStyle(
                  color: Color.fromRGBO(18, 13, 38, 1),
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            actions: [
              InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Search(),
                      ),
                    );
                  },
                  child: SvgPicture.asset('assets/icons/search_black.svg')),
              SizedBox(
                width: 20,
              ),
              Icon(Icons.more_vert, color: Color.fromRGBO(18, 13, 38, 1)),
              SizedBox(
                width: 20,
              ),
            ],
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          body: BlocBuilder<EventsCubit, EventsState>(
            builder: (context, state) {
              if (state.state == EventsStateEnum.loading) {
                return Center(child: CircularProgressIndicator());
              } else if (state.state == EventsStateEnum.loaded) {
                return ListView.builder(
                  itemCount: state.eventList?.length ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EventDetail(event: state.eventList![index]),
                            ),
                          );
                        },
                        child: EventTile(event: state.eventList![index]));
                  },
                );
              } else if (state.state == EventsStateEnum.error) {
                return Center(child: Text('Error: ${state.error}'));
              } else {
                return Center(child: Text('Loading Events'));
              }
            },
          )),
    );
  }
}

class EventTile extends StatelessWidget {
  const EventTile({
    super.key,
    required this.event,
  });

  final Event event;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: ListTile(
          leading: Image.network(
            event.bannerImage,
            loadingBuilder: (BuildContext context, Widget child,
                ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }
              return CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              );
            },
          ),
          title: Text(formatDateTime(event.dateTime),
              style: TextStyle(
                  fontSize: 13,
                  color: Color.fromRGBO(86, 105, 255, 1),
                  fontWeight: FontWeight.w400)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 5,
              ),
              Text(event.title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color.fromRGBO(18, 13, 38, 1),
                  )),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset('assets/icons/map-pin.svg'),
                  SizedBox(
                    width: 5,
                  ),
                  Flexible(
                    child: Text(
                        event.venueName +
                            ' • ' +
                            event.venueCity +
                            ', ' +
                            event.venueCountry,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Color.fromRGBO(116, 118, 136, 1),
                        )),
                  ),
                ],
              ),
            ],
          ),
          dense: false,
        ),
      ),
    );
  }
}
