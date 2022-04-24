import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FeedWidget extends StatefulWidget {
  const FeedWidget({Key? key}) : super(key: key);

  @override
  State<FeedWidget> createState() => _FeedWidgetState();
}

class _FeedWidgetState extends State<FeedWidget> {
  final String url = "https://api.spaceflightnewsapi.net/v3/articles?_limit=5";
  late final List result1;

  bool isLoading = true;
  fetchData() async {
    var result = await http.get(Uri.parse(url));
    result1 = jsonDecode(result.body);
    //data = jsonDecode(result.body)['title'];
    //img = jsonDecode(result.body)['imageUrl'];
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : ListView.builder(
            itemCount: result1.length,
            itemBuilder: ((context, index) {
              final data = result1[index]['title'];
              return Stack(children: [
                Container(
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                  height: 140,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: NetworkImage(
                        result1[index]['imageUrl'],
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  child: Text(
                    data,
                    style: TextStyle(color: Colors.white),
                  ),
                  bottom: 10,
                  left: 10,
                )
              ]);
            }),
          );
  }
}
