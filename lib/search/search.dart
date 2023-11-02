import 'package:event_app/event_details/event_details.dart';
import 'package:event_app/model/event_model.dart';
import 'package:event_app/search/bloc/search_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../util/dateTime.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  late SearchBloc searchBloc;

  @override
  void initState() {
    super.initState();
    searchBloc = SearchBloc();
    searchBloc.add(PerformSearch(''));
  }

  @override
  void dispose() {
    searchBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => searchBloc,
      child: Scaffold(
          appBar: AppBar(
            leading: Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 5,
                top: 5,
                bottom: 5,
              ),
              child:
                  Icon(Icons.arrow_back, color: Color.fromRGBO(18, 13, 38, 1)),
            ),
            title: Text(
              "Search",
              style: TextStyle(
                color: Color.fromRGBO(18, 13, 38, 1),
                fontSize: 24,
                fontWeight: FontWeight.w500,
              ),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          body: Column(
            children: [
              Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      SvgPicture.asset('assets/icons/search_blue.svg'),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal:5),
                        child: Text('|',
                        style:TextStyle(
                                  color: Color.fromRGBO(121, 116, 231, 1)
                      ,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w400,
                                ),
                        ),
                      ),
                      Flexible(
                        child: TextField(
                          style:  TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 1),
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                              ),
                          onChanged: (text) {
                            searchBloc.add(PerformSearch(text));
                          },
                          decoration: InputDecoration(
                              hintText: 'Type Event Name',
                              hintStyle: TextStyle(
                                color: Color.fromRGBO(0, 0, 0, 0.4),
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                              ),
                              border: InputBorder.none,
                              alignLabelWithHint: true),
                        ),
                      ),
                    ],
                  )),
              Expanded(
                child: BlocBuilder<SearchBloc, SearchState>(
                  builder: (context, state) {
                    if (state.state == SearchStateEnum.loading) {
                      return Center(child: CircularProgressIndicator());
                    } else if (state.state == SearchStateEnum.loaded) {
                      return state.searchResults?.length == 0
                          ? Center(child: Text('No Result Found'))
                          : ListView.builder(
                              itemCount: state.searchResults?.length ?? 0,
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EventDetail(
                                              event:
                                                  state.searchResults![index]),
                                        ),
                                      );
                                    },
                                    child: EventTile(
                                        event: state.searchResults![index]));
                              },
                            );
                    } else if (state.state == SearchStateEnum.error) {
                      return Center(child: Text('Error: ${state.error}'));
                    } else {
                      return Center(child: Text('Loading Events'));
                    }
                  },
                ),
              ),
            ],
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
        padding: EdgeInsets.all(8),
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
            ],
          ),
          dense: false,
        ),
      ),
    );
  }
}
