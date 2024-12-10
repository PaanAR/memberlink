import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mymemberlinks/views/shared/mydrawer.dart';

import 'new_event.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Events",
          style: GoogleFonts.monoton(color: const Color(0xFFF4F3EE)),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF463F3A),
        iconTheme: const IconThemeData(
          color: Color(0xFFF4F3EE), // Light Beige for the hamburger icon
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.refresh_rounded,
                color: Color(0xFFF4F3EE)), // Light Beige
          )
        ], //
      ),
      body: const Center(child: Text("Events...")),
      drawer: const MyDrawer(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFE0AFA0), // Soft Peach
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (content) => const NewEventScreen()));
          //loadNewsData();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void loadNewsData() {}
}
