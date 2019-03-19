import 'dart:async';
import 'dart:convert'; // json decode
import 'package:flutter_news_reader/model/model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

String API_KEY = "YOUR_API_KEY";

Future<List<Article>> fetchArticleBySource(String source) async {
  final response = await http.get('https://newsapi.org/v2/top-headlines?sources=${source}&apiKey=${API_KEY}');

  // http OK
  if(response.statusCode == 200){
    List articles = json.decode(response.body)['articles'];
    return articles.map((article) => new Article.fromJson(article)).toList();
  } else {
    throw Exception("Failed to load article list");
  }
}

class ArticleScreen extends StatefulWidget {
  final Source source;

  ArticleScreen({Key key, @required this.source}):super(key: key);

  @override
  State<StatefulWidget> createState() => ArticleScreenState();
}

class ArticleScreenState extends State<ArticleScreen> {
  var list_articles;
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState(){
    refreshListArticle();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "FLUTTER NEWS",
      theme: ThemeData(primarySwatch: Colors.teal),
      home: Scaffold(
        appBar: AppBar(
          title: Text(widget.source.name),
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {

                },
              );
            },
          ),
        ),
        body: Center(
          child: RefreshIndicator(
              key: refreshKey,
              child: FutureBuilder<List<Article>>(
                future: list_articles,
                builder: (context, snapshot){
                  if(snapshot.hasError){
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData){
                    List<Article> articles = snapshot.data;
                    return ListView(
                      children: articles.map((article) => GestureDetector(
                        onTap: (){
                          _launchUrl(article.url);
                        },
                        child: Card(
                          elevation: 1,
                          color: Colors.white,
                          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 4),
                                width: 100,
                                height: 100,
                                child: article.urlToImage != null ? Image.network(article.urlToImage):Image.asset('assets/news.jpg'),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: Container(
                                            margin: const EdgeInsets.only(left: 8, top: 20, bottom: 10),
                                            child: Text('${article.title}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(left: 8),
                                      child: Text("${article.description}", style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold),),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(left: 8, top: 10, bottom: 10),
                                      child: Text("Published At: ${article.publishedAt}", style: TextStyle(color: Colors.black12, fontSize: 12, fontWeight: FontWeight.bold),),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),).toList(),
                    );
                  }
                  return CircularProgressIndicator();
                },
              ),
              onRefresh: refreshListArticle
          ),
        ),
      ),
    );
  }

  Future<Null> refreshListArticle() async {
    refreshKey.currentState?.show(atTop: false);
    setState(() {
      list_articles = fetchArticleBySource(widget.source.id);
    });
    return null;
  }

  _launchUrl(String url) async {
    if(await canLaunch(url)){
      await launch(url);
    } else {
      throw ("Could not launch ${url}");
    }
  }
}