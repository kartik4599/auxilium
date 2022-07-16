import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String username;
  final String uid;
  final String description;
  final String postId;
  final String postUrl;
  final datePublish;
  final String profImage;
  final likes;

  const Post(
      {required this.username,
      required this.description,
      required this.uid,
      required this.postId,
      required this.postUrl,
      required this.profImage,
      required this.datePublish,
      required this.likes});

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "description": description,
        "postId": postId,
        "postUrl": postUrl,
        "profImage": profImage,
        "datePublish": datePublish,
        "likes": likes
      };

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return Post(
        username: snapshot["username"],
        uid: snapshot["uid"],
        description: snapshot["description"],
        postUrl: snapshot["postUrl"],
        postId: snapshot["postId"],
        profImage: snapshot["profImage"],
        likes: snapshot["likes"],
        datePublish: snapshot["datePublish"]);
  }
}
