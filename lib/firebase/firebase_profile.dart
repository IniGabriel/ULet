import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseProfile {
  // To send the image url to 'profile_page.dart' so that it can load the image
  Future <String> getImageUrl(String imageName) async {
    try{
    final userLink = FirebaseStorage.instance.refFromURL('gs://ulet-a6713.appspot.com/$imageName');
    String downloadUserLink = await userLink.getDownloadURL();
    return downloadUserLink;
    }
    catch(e){
    final userLink = FirebaseStorage.instance.refFromURL('gs://ulet-a6713.appspot.com/tester.jpg');
    String downloadUserLink = await userLink.getDownloadURL();
    return downloadUserLink;
    }
  }

// To change profile picture, and save it to Firebase Storage
  void changeProfile(String phoneNumber, XFile file) async{
    try{
      final storageRef = FirebaseStorage.instance.ref();
      final String fileName = phoneNumber;
      final imageRef = storageRef.child(fileName);
      await imageRef.putFile(File(file.path));
    } 
    catch (e){
      print('Error during profile picture upload: $e');
    }
  }

  // To change username ,and store it to Firebase
  void changeUsername (String newUsername, String userId) async {
    try{
      FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .set({'full_name': newUsername}, SetOptions(merge: true))
        .then((_) {
      print('Username updated successfully');
    });

    } 
    catch(e){
      print('User belum pernah mengganti profile picturenya!');
    }
  }
}