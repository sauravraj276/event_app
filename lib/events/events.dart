import 'package:flutter/material.dart';

class Events extends StatefulWidget {
  const Events({super.key});

  @override
  State<Events> createState() => _EventsState();
}

class _EventsState extends State<Events> {
  final List<String> dataList = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Events",
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Icon(Icons.search),
          SizedBox(
            width: 20,
          ),
          Icon(Icons.more_vert),
          SizedBox(
            width: 20,
          ),
        ],
        foregroundColor: Colors.black,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: ListView.builder(
        itemCount: 20,
        itemBuilder: (BuildContext context, int index) {
          return EventTile(dataList: dataList);
        },
      ),
    );
  }
}

class EventTile extends StatelessWidget {
  const EventTile({
    super.key,
    required this.dataList,
  });

  final List<String> dataList;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1, // Set the elevation for the Card
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(12.0), // Adjust the radius as needed
      ),
      margin: EdgeInsets.symmetric(
          vertical: 8, horizontal: 16), // Adjust the gap here
      child: ListTile(
        leading: CircleAvatar(),
        title: Text('Wed, Apr 28 • 5:30 PM',
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
            Text('''Jo Malone London’s Mother’s Day Presents''',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.location_on),
                Text('''Jo Malone London’s Mother’s Day Presents''',
                    style:
                        TextStyle(fontSize: 13, fontWeight: FontWeight.w400)),
              ],
            ),
          ],
        ),
        dense: false,
      ),
    );
  }
}
