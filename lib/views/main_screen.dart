// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mymemberlinks/models/news.dart';

import 'package:http/http.dart' as http;
import 'package:mymemberlinks/views/edit_news.dart';
import 'package:mymemberlinks/views/new_news.dart';

import '../myconfig.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<News> newsList = [];
  final df = DateFormat('dd/MM/yyy hh:mm a');
  int numofpage = 1;
  int currpage = 1;
  int numofresult = 0;
  var color;
  late double screenWidth, screenHeight;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadNewsData();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("NewsLetter"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                loadNewsData();
              },
              icon: Icon(Icons.refresh_rounded))
        ],
      ),
      body: newsList.isEmpty
          ? const Center(
              child: Text("Loading..."),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: newsList.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                          key: Key(newsList[index]
                              .newsId
                              .toString()), // Unique key for each item
                          direction: DismissDirection.endToStart,
                          background: Container(
                            color: Colors.red,
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: const Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                          ),
                          confirmDismiss: (direction) async {
                            return await showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("Confirm Delete"),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                          "Are you sure you want to delete this news?"),
                                      const SizedBox(height: 10),
                                      Text(
                                        "Title: ${newsList[index].newsTitle}",
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.left,
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        "Details: ${truncateString(newsList[index].newsDetails.toString(), 50)}",
                                        textAlign: TextAlign.left,
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(false); // Cancel deletion
                                      },
                                      child: const Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        deleteNews(index); // Perform deletion
                                        Navigator.of(context)
                                            .pop(true); // Confirm dismissal
                                      },
                                      child: const Text("Delete"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Card(
                            child: ListTile(
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    truncateString(
                                      newsList[index].newsTitle.toString(),
                                      30,
                                    ),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (newsList[index].isEdited == true)
                                    Text(
                                      "Edited",
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontStyle: FontStyle.italic,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  Text(
                                    df.format(
                                      DateTime.parse(
                                        newsList[index].newsDate.toString(),
                                      ),
                                    ),
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                              subtitle: Text(
                                truncateString(
                                    newsList[index].newsDetails.toString(),
                                    100),
                                textAlign: TextAlign.justify,
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.arrow_forward),
                                onPressed: () {
                                  showNewsDetailDialog(index);
                                },
                              ),
                            ),
                          ));
                    },
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.05,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: numofpage,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      //build the list for textbutton with scroll
                      if ((currpage - 1) == index) {
                        //set current page number active
                        color = Colors.red;
                      } else {
                        color = Colors.black;
                      }
                      return TextButton(
                          onPressed: () {
                            currpage = index + 1;
                            loadNewsData();
                          },
                          child: Text(
                            (index + 1).toString(),
                            style: TextStyle(color: color, fontSize: 18),
                          ));
                    },
                  ),
                )
              ],
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
        onPressed: () async {
          await Navigator.push(context,
              MaterialPageRoute(builder: (content) => const NewNewsScreen()));
          loadNewsData();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  String truncateString(String str, int length) {
    if (str.length > length) {
      str = str.substring(0, length);
      return "$str...";
    } else {
      return str;
    }
  }

  void loadNewsData() {
    // Build the URL with the current page
    final url = Uri.parse(
        "${MyConfig.servername}/mymemberlink/api/load_news.php?pageno=$currpage");

    http.get(url).then((response) {
      // Log the raw response for debugging
      log("Response: ${response.body}");

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        // Check if the server responded with success
        if (data['status'] == "success") {
          var result = data['data']['news'];
          newsList.clear(); // Clear existing newsList to avoid duplicates

          // Parse and add news items
          for (var item in result) {
            News news =
                News.fromJson(item); // Ensure mapping includes `isEdited`
            newsList.add(news);

            // Debug: Log each news item
            log("News Title: ${news.newsTitle}, Is Edited: ${news.isEdited}");
          }

          // Update pagination details
          numofpage = int.parse(data['numofpage'].toString());
          numofresult = int.parse(data['numberofresult'].toString());

          log("Total Pages: $numofpage, Total Results: $numofresult");

          setState(() {}); // Refresh the UI
        } else {
          // Server returned a failure status
          log("Failed to load news: ${data['message'] ?? 'Unknown error'}");
        }
      } else {
        // Handle HTTP errors
        log("HTTP Error: ${response.statusCode}, ${response.reasonPhrase}");
      }
    }).catchError((error) {
      // Handle network or parsing errors
      log("Error occurred: $error");
    });
  }

  void showNewsDetailDialog(int index) {
    showDialog(
        context: context,
        builder: (contex) {
          return AlertDialog(
            title: Text(newsList[index].newsTitle.toString()),
            content: Text(
              newsList[index].newsDetails.toString(),
              textAlign: TextAlign.justify,
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Close")),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  News news = newsList[index];
                  print(news.newsDetails);
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (content) => EditNewsScreen(news: news)));
                  loadNewsData();
                },
                child: const Text("Edit ?"),
              )
            ],
          );
        });
  }

  void deleteNews(int index) {
    // Save the news ID before removing it from the list
    String newsId = newsList[index].newsId.toString();

    // Remove the item from the list locally to update the UI
    setState(() {
      newsList.removeAt(index);
    });

    // Send the delete request to the backend
    http.post(
      Uri.parse("${MyConfig.servername}/mymemberlink/api/delete_news.php"),
      body: {'news_id': newsId},
    ).then((response) {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("News deleted successfully")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text("Failed to delete news: ${data['message']}")),
          );
        }
      } else {
        // Re-add the item back to the list if the server operation failed
        setState(() {
          newsList.insert(
              index, News(newsId: newsId)); // Insert the removed item back
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Server error: Unable to delete news")),
        );
      }
    }).catchError((error) {
      // Handle unexpected errors
      setState(() {
        newsList.insert(index, News(newsId: newsId));
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $error")),
      );
    });
  }
}
