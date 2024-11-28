import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mymemberlinks/models/news.dart';

import 'package:http/http.dart' as http;
import 'package:mymemberlinks/views/new_news.dart';

import '../myconfig.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<News> newsList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadNewsData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("NewsLetter"),
        centerTitle: true,
      ),
      body: newsList.isEmpty
          ? const Center(
              child: Text("Loading..."),
            )
          : ListView.builder(
              itemCount: newsList.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(truncateString(
                        newsList[index].newsTitle.toString(), 30)),
                    subtitle: Text(
                      truncateString(
                          newsList[index].newsDetails.toString(), 100),
                      textAlign: TextAlign.justify,
                    ),
                    leading: const Icon(Icons.article),
                    trailing: IconButton(
                        icon: const Icon(Icons.arrow_forward),
                        onPressed: () {}),
                  ),
                );
              }),
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
    http
        .get(Uri.parse("${MyConfig.servername}/mymemberlink/api/load_news.php"))
        .then((response) {
      log(response.body.toString());
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (data['status'] == "success") {
          var result = data['data']['news'];
          newsList.clear();
          for (var item in result) {
            News news = News.fromJson(item);
            newsList.add(news);
            print(news.newsTitle);
          }
          setState(() {});
        }
      } else {
        print("Error");
      }
    });
  }
}
