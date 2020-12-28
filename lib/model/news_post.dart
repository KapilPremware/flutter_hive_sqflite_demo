class NewsPost {
  String postId;
  String userId;

  NewsPost({this.postId, this.userId});

  //Convert a DBNote Object into a Map Object
  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['postId'] = postId;
    map['userId'] = userId;
    return map;
  }

  //Convert a Map Object into a DBNote Object
  NewsPost.fromMapObject(Map<String, dynamic> map) {
    this.postId = map["postId"];
    this.userId = map["userId"];
  }

  factory NewsPost.fromJson(Map<String, dynamic> json) {
    return NewsPost(
        postId: json['postId'] as String,
        userId: json['userId'] as String);
  }
}