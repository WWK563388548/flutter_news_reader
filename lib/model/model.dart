// Create Data model for NewsApi
class Source {
  final String id;
  final String name;
  final String description;
  final String url;
  final String category;
  final String language;
  final String country;

  Source({this.id, this.name, this.description, this.url, this.category, this.language, this.country});

  factory Source.fromJson(Map<String, dynamic> json){
    return Source(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      url: json['url'],
      category: json['category'],
      language: json['language'],
      country: json['country'],
    );
  }
}

class NewsApi {
  final String status;
  final List<Source> sources;

  NewsApi({this.status, this.sources});

  factory NewsApi.fromJson(Map<String, dynamic> json){
    return NewsApi(
      status: json['status'],
      sources: (json['sources'] as List).map((source) => Source.fromJson(source)).toList(),
    );
  }
}