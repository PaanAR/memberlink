import 'package:flutter/material.dart';
import 'package:mymemberlinks/views/new_news.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: const Center(
          child: Text("MAIN SCREEN"),
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                child: Text("Drawer Header"),
              ),
              ListTile(
                onTap: () {},
                title: const Text("Newsletter"),
              ),
              ListTile(
                onTap: () {},
                title: const Text("Events"),
              ),
              ListTile(
                onTap: () {},
                title: const Text("Members"),
              ),
              ListTile(
                onTap: () {},
                title: const Text("Vetting"),
              ),
              ListTile(
                onTap: () {},
                title: const Text("Resources"),
              ),
              ListTile(
                onTap: () {},
                title: const Text("Payments"),
              ),
              ListTile(
                onTap: () {},
                title: const Text("Products"),
              ),
              ListTile(
                onTap: () {},
                title: const Text("Mailings"),
              ),
              ListTile(
                onTap: () {},
                title: const Text("Committee"),
              ),
              ListTile(
                onTap: () {},
                title: const Text("Settings"),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (content) => const NewNewsScreen()));
          },
          child: const Icon(Icons.add),
        ));
  }
}
