import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter_news_reader/model/model.dart';
import 'dart:convert';

String API_KEY = "YOUR_NEWS_API_KEY";

Future<List<Source>> fetchNewsSource() async {
  final response = await http.get('https://newsapi.org/v2/sources?apiKey=${API_KEY}');

  // http OK
  if(response.statusCode == 200){
    List sources = json.decode(response.body)['sources'];
    return sources.map((source) => new Source.fromJson(source)).toList();
  } else {
    throw Exception("Failed to load source list");
  }
}

void main() => runApp(
    MainScreen()
);


// Create Main Screen(Stateful)
class MainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {

  var list_sources;
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState(){
    super.initState();

    // refreshListSource();
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }
}