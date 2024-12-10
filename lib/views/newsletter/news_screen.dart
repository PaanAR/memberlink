import 'dart:convert';
import 'dart:developer';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mymemberlinks/models/news.dart';

import 'package:http/http.dart' as http;
import 'package:mymemberlinks/views/edit_news.dart';
import 'package:mymemberlinks/views/mydrawer.dart';
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
    super.initState();
    loadNewsData();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "NewsLetter",
          style: GoogleFonts.monoton(color: const Color(0xFFF4F3EE)),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF463F3A),
        iconTheme: const IconThemeData(
          color: Color(0xFFF4F3EE), // Light Beige for the hamburger icon
        ), // Dark Brown
        actions: [
          IconButton(
            onPressed: () {
              loadNewsData();
            },
            icon: const Icon(Icons.refresh_rounded,
                color: Color(0xFFF4F3EE)), // Light Beige
          )
        ],
      ),
      body: newsList.isEmpty
          ? const Center(
              child: Text(
                "Loading...",
                style: TextStyle(color: Color(0xFF463F3A)), // Dark Brown
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: newsList.length,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        key: Key(newsList[index].newsId.toString()),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: const Color(0xFFE0AFA0), // Soft Peach
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
                                backgroundColor:
                                    const Color(0xFFF4F3EE), // Light Beige
                                title: const Text(
                                  "Confirm Delete",
                                  style: TextStyle(
                                      color: Color(0xFF463F3A)), // Dark Brown
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      "Are you sure you want to delete this news?",
                                      style:
                                          TextStyle(color: Color(0xFF463F3A)),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      "Title: ${newsList[index].newsTitle}",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF463F3A),
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      "Details: ${truncateString(newsList[index].newsDetails.toString(), 50)}",
                                      style: const TextStyle(
                                          color: Color(
                                              0xFF8A817C)), // Grayish Brown
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(false);
                                    },
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      deleteNews(index);
                                      Navigator.of(context).pop(true);
                                    },
                                    child: const Text("Delete"),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: Card(
                          color: const Color(0xFFBCB8B1), // Light Grayish Brown
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
                                    color: Color(0xFF463F3A),
                                  ),
                                ),
                                if (newsList[index].isEdited == true)
                                  const Text(
                                    "Edited",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontStyle: FontStyle.italic,
                                      color: Color(0xFF8A817C),
                                    ),
                                  ),
                                Text(
                                  df.format(
                                    DateTime.parse(
                                      newsList[index].newsDate.toString(),
                                    ),
                                  ),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF463F3A),
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Text(
                              truncateString(
                                  newsList[index].newsDetails.toString(), 100),
                              style: const TextStyle(
                                  color:
                                      const Color(0xFF463F3A)), // Grayish Brown
                              textAlign: TextAlign.justify,
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.arrow_forward,
                                  color: Color(0xFF463F3A)),
                              onPressed: () {
                                showNewsDetailDialog(index);
                              },
                            ),
                          ),
                        ),
                      );
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
                      if ((currpage - 1) == index) {
                        color = const Color(0xFF463F3A); // Dark Brown
                      } else {
                        color = const Color(0xFF8A817C); // Grayish Brown
                      }
                      return TextButton(
                        onPressed: () {
                          currpage = index + 1;
                          loadNewsData();
                        },
                        child: Text(
                          (index + 1).toString(),
                          style: TextStyle(color: color, fontSize: 18),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
      drawer: const MyDrawer(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFE0AFA0), // Soft Peach
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
    final url = Uri.parse(
        "${MyConfig.servername}/mymemberlink/api/load_news.php?pageno=$currpage");

    http.get(url).then((response) {
      log("Response: ${response.body}");

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        if (data['status'] == "success") {
          var result = data['data']['news'];
          newsList.clear();

          for (var item in result) {
            News news = News.fromJson(item);
            newsList.add(news);
          }

          numofpage = int.parse(data['numofpage'].toString());
          numofresult = int.parse(data['numberofresult'].toString());

          setState(() {});
        } else {
          log("Failed to load news: ${data['message'] ?? 'Unknown error'}");
        }
      } else {
        log("HTTP Error: ${response.statusCode}, ${response.reasonPhrase}");
      }
    }).catchError((error) {
      log("Error occurred: $error");
    });
  }

  void showNewsDetailDialog(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFF4F3EE), // Light Beige
          title: Text(
            newsList[index].newsTitle.toString(),
            style: const TextStyle(color: Color(0xFF463F3A)), // Dark Brown
          ),
          content: Text(
            newsList[index].newsDetails.toString(),
            style: const TextStyle(color: Color(0xFF8A817C)), // Grayish Brown
            textAlign: TextAlign.justify,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Close"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                News news = newsList[index];
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (content) => EditNewsScreen(news: news)),
                );
                loadNewsData();
              },
              child: const Text("Edit ?"),
            )
          ],
        );
      },
    );
  }

  void deleteNews(int index) {
    String newsId = newsList[index].newsId.toString();

    setState(() {
      newsList.removeAt(index);
    });

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
        setState(() {
          newsList.insert(index, News(newsId: newsId));
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Server error: Unable to delete news")),
        );
      }
    }).catchError((error) {
      setState(() {
        newsList.insert(index, News(newsId: newsId));
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $error")),
      );
    });
  }
}
