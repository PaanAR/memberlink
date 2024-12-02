import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mymemberlinks/models/news.dart';
import 'package:mymemberlinks/myconfig.dart';
import 'package:http/http.dart' as http;

class EditNewsScreen extends StatefulWidget {
  final News news;
  const EditNewsScreen({super.key, required this.news});

  @override
  State<EditNewsScreen> createState() => _EditNewsScreenState();
}

class _EditNewsScreenState extends State<EditNewsScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController detailsController = TextEditingController();

  late double screenWidth, screenHeight;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    titleController.text = widget.news.newsTitle.toString();
    detailsController.text = widget.news.newsDetails.toString();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Newsletter"),
        centerTitle: true,
      ),
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
                      hintText: "News Title")),
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
                      hintText: "News Details"),
                  maxLines: screenHeight ~/ 35,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              MaterialButton(
                  elevation: 10,
                  onPressed: onUpdateNewsDialog,
                  minWidth: 400,
                  height: 50,
                  color: Colors.purple[800],
                  child: isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text("Update",
                          style: TextStyle(color: Colors.white))),
              const SizedBox(
                height: 10,
              ),
              MaterialButton(
                  elevation: 10,
                  onPressed: clearFields,
                  minWidth: 400,
                  height: 50,
                  color: Colors.grey[600],
                  child: const Text("Clear Fields",
                      style: TextStyle(color: Colors.white))),
            ],
          ),
        ),
      ),
    );
  }

  void onUpdateNewsDialog() {
    if (titleController.text.isEmpty || detailsController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please fill in both fields."),
        backgroundColor: Colors.red,
      ));
      return;
    }
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Update"),
        content: const Text("Are you sure you want to update this news?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              updateNews();
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }

  void updateNews() async {
    setState(() {
      isLoading = true;
    });

    try {
      var response = await http.post(
        Uri.parse("${MyConfig.servername}/mymemberlink/api/update_news.php"),
        body: {
          "news_id": widget.news.newsId.toString(),
          "news_title": titleController.text,
          "news_details": detailsController.text,
          "is_edited": "1",
        },
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("News updated successfully!")),
          );
          Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to update news")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Server error")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void clearFields() {
    setState(() {
      titleController.clear();
      detailsController.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Fields cleared"),
      backgroundColor: Colors.blue,
    ));
  }
}
