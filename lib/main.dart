import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter_news_reader/model/model.dart';
import 'dart:convert';

String API_KEY = "YOUR_API_KEY";

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

    refreshListSource();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "FLUTTER NEWS",
      theme: ThemeData(primarySwatch: Colors.teal),
      home: Scaffold(
        appBar: AppBar(
          title: Text("FLUTTER NEWS"),
        ),
        body: Center(
          child: RefreshIndicator(
              key: refreshKey,
              child: FutureBuilder<List<Source>>(
                future: list_sources,
                builder: (context, snapshot){
                  if(snapshot.hasError){
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData){
                    List<Source> sources = snapshot.data;
                    return ListView(
                      children: sources.map((source) => GestureDetector(
                        onTap: (){},
                        child: Card(
                          elevation: 1.0,
                          color: Colors.white,
                          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 14.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 2.0),
                                width: 100,
                                height: 140,
                                child: Image.asset("assets/news.jpg"),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Container(
                                            margin: const EdgeInsets.only(top: 20, bottom: 10),
                                            child: Text('${source.name}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      child: Text('${source.description}', style: TextStyle(color: Colors.grey, fontSize: 12),),
                                    ),
                                    Container(
                                      child: Text('Category: ${source.category}', style: TextStyle(color: Colors.black, fontSize: 14),),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )).toList(),
                    );
                  }
                  return CircularProgressIndicator();
                },
              ),
              onRefresh: refreshListSource,
          ),
        ),
      ),
    );
  }

  Future<Null> refreshListSource() {
    refreshKey.currentState?.show(atTop: false);
    setState(() {
      list_sources = fetchNewsSource();
    });
    return null;
  }
}