import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import '../myconfig.dart';

class NewNewsScreen extends StatefulWidget {
  const NewNewsScreen({super.key});

  @override
  State<NewNewsScreen> createState() => _NewNewsScreenState();
}

class _NewNewsScreenState extends State<NewNewsScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController detailsController = TextEditingController();

  late double screenWidth, screenHeight;

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "New Newsletter",
          style: GoogleFonts.monoton(color: const Color(0xFFF4F3EE)),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF463F3A), // Dark brown
        iconTheme: const IconThemeData(
          color: Color(0xFFF4F3EE), // Light cream for back arrow
        ),
      ),
      backgroundColor: const Color(0xFFF4F3EE), // Light cream background
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  filled: true,
                  fillColor: Color(0xFFBCB8B1), // Greyish beige
                  hintText: "News Title",
                  hintStyle: TextStyle(color: Color(0xFF8A817C)), // Taupe
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                height: screenHeight * 0.6,
                child: TextField(
                  controller: detailsController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    filled: true,
                    fillColor: Color(0xFFBCB8B1), // Greyish beige
                    hintText: "News Details",
                    hintStyle: TextStyle(color: Color(0xFF8A817C)), // Taupe
                  ),
                  maxLines: screenHeight ~/ 35,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              MaterialButton(
                elevation: 10,
                onPressed: onInsertNewsDialog,
                minWidth: 400,
                height: 50,
                color: const Color(0xFFE0AFA0), // Peachy beige
                child: const Text(
                  "Insert",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              MaterialButton(
                elevation: 10,
                onPressed: clearFields,
                minWidth: 400,
                height: 50,
                color: const Color(0xFF8A817C), // Taupe
                child: const Text(
                  "Clear All",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onInsertNewsDialog() {
    if (titleController.text.isEmpty || detailsController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please enter title and details"),
        backgroundColor: Colors.red,
      ));
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Insert this newsletter?",
            style: TextStyle(),
          ),
          content: const Text("Are you sure?", style: TextStyle()),
          actions: <Widget>[
            TextButton(
              child: const Text(
                "Yes",
                style: TextStyle(),
              ),
              onPressed: () {
                insertNews();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                "No",
                style: TextStyle(),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void insertNews() {
    String title = titleController.text;
    String details = detailsController.text;
    http.post(
        Uri.parse("${MyConfig.servername}/mymemberlink/api/insert_news.php"),
        body: {"title": title, "details": details}).then((response) {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Insert Success"),
            backgroundColor: Colors.green,
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Insert Failed"),
            backgroundColor: Colors.red,
          ));
        }
      }
    });
  }

  void clearFields() {
    setState(() {
      titleController.clear();
      detailsController.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("All fields cleared"),
      backgroundColor: Colors.blue,
    ));
  }
}
