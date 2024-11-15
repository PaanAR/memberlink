import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
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
              const ListTile(
                title: Text("Events"),
              ),
              const ListTile(
                title: Text("Members"),
              ),
              const ListTile(
                title: Text("Vetting"),
              ),
              const ListTile(
                title: Text("Resources"),
              ),
              const ListTile(
                title: Text("Payments"),
              ),
              const ListTile(
                title: Text("Products"),
              ),
              const ListTile(
                title: Text("Mailings"),
              ),
              const ListTile(
                title: Text("Committee"),
              ),
              const ListTile(
                title: Text("Settings"),
              ),
            ],
          ),
        ));
  }
}
