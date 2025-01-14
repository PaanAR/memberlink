import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mymemberlinks/views/shared/mydrawer.dart';
import 'package:mymemberlinks/model/user.dart';
import 'package:mymemberlinks/myconfig.dart';
import 'package:mymemberlinks/model/event.dart';
import 'package:mymemberlinks/views/events/new_event.dart';

class EventScreen extends StatefulWidget {
  final User user;
  const EventScreen({super.key, required this.user});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  List<MyEvent> eventsList = [];
  String status = "Loading...";
  late double screenHeight, screenWidth;
  final df = DateFormat('dd/MM/yyyy hh:mm a');

  @override
  void initState() {
    super.initState();
    loadEvents();
  }

  Future<void> loadEvents() async {
    // Implement your event loading logic here
  }

  String truncateString(String str, int size) {
    if (str.length > size) {
      str = str.substring(0, size);
      return "$str...";
    } else {
      return str;
    }
  }

  void deleteDialog(int index) {
    // Implement delete dialog
  }

  void showEventDetailsDialog(int index) {
    // Implement event details dialog
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Events",
          style: GoogleFonts.monoton(color: const Color(0xFFF4F3EE)),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF463F3A),
        iconTheme: const IconThemeData(
          color: Color(0xFFF4F3EE),
        ),
        actions: [
          IconButton(onPressed: loadEvents, icon: const Icon(Icons.refresh))
        ],
      ),
      body: eventsList.isEmpty
          ? Center(
              child: Text(
                status,
                style: const TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            )
          : GridView.count(
              childAspectRatio: 0.75,
              crossAxisCount: 2,
              children: List.generate(eventsList.length, (index) {
                return Card(
                  child: InkWell(
                    splashColor: Colors.red,
                    onLongPress: () {
                      deleteDialog(index);
                    },
                    onTap: () {
                      showEventDetailsDialog(index);
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(4, 8, 4, 4),
                      child: Column(children: [
                        Text(
                          eventsList[index].eventTitle.toString(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              overflow: TextOverflow.ellipsis),
                        ),
                        SizedBox(
                          child: Image.network(
                            "${MyConfig.servername}/memberlink/assets/events/${eventsList[index].eventFilename}",
                            errorBuilder: (context, error, stackTrace) =>
                                SizedBox(
                              height: screenHeight / 6,
                              child: Image.asset(
                                "assets/images/na.png",
                              ),
                            ),
                            width: screenWidth / 2,
                            height: screenHeight / 6,
                            fit: BoxFit.cover,
                            scale: 4,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
                          child: Text(
                            eventsList[index].eventType.toString(),
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Text(df.format(DateTime.parse(
                            eventsList[index].eventDate.toString()))),
                        Text(truncateString(
                            eventsList[index].eventDescription.toString(), 45)),
                      ]),
                    ),
                  ),
                );
              })),
      drawer: MyDrawer(user: widget.user),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFE0AFA0),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (content) => const NewEventScreen()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
