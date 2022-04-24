import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FeedWidget extends StatefulWidget {
  const FeedWidget({Key? key}) : super(key: key);

  @override
  State<FeedWidget> createState() => _FeedWidgetState();
}

class _FeedWidgetState extends State<FeedWidget> {
  final String url = "https://api.spaceflightnewsapi.net/v3/articles?_limit=5";

  bool isLoading = true;
  fetchData() async {
    var result = await http.get(Uri.parse(url));
    print(result.body);
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
        : Container();
  }
}
