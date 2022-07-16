import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:instagram_demo/models/post.dart';
import 'package:instagram_demo/resources/storage_method.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //upload post
  Future<String> uploadPost(String description, Uint8List file, String uid,
      String username, String profImage) async {
    String res = "Some Error Occured";
    try {
      String photoUrl =
          await StorageMethod().uploadImageToStorage("posts", file, true);
      String postId = const Uuid().v1();

      Post post = Post(
          username: username,
          description: description,
          uid: uid,
          postId: postId,
          postUrl: photoUrl,
          profImage: profImage,
          datePublish: DateTime.now(),
          likes: []);
      _firestore.collection("post").doc(postId).set(post.toJson());
      res = "sucess";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  //Like A Post
  Future<void> likePost(
      String postId, String uid, List likes, bool double) async {
    try {
      if (double) {
        if (likes.contains(uid)) {
          await _firestore.collection('post').doc(postId).update({
            'likes': FieldValue.arrayRemove([uid]),
          });
        } else {
          await _firestore.collection('post').doc(postId).update({
            'likes': FieldValue.arrayUnion([uid]),
          });
        }
      } else {
        await _firestore.collection('post').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {}
  }

//Post Comment
  Future<String> postComment(String postId, String text, String uid,
      String name, String profImage) async {
    String res = "Some err occured";
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firestore
            .collection('post')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profImage': profImage,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
          'likes': []
        });
        res = "sucesss";
      } else {
        res = "empty";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  //Delete Post
  Future<void> deletePost(String postId) async {
    try {
      _firestore.collection('post').doc(postId).delete();
    } catch (er) {
      print(er.toString());
    }
  }

  //follow user
  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('Users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        await _firestore.collection('Users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await _firestore.collection('Users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('Users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });
        await _firestore.collection('Users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (er) {
      print("==>$er");
    }
  }
}
