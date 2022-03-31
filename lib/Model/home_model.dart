import 'package:cloud_firestore/cloud_firestore.dart';

class HomeModel {
  final String post , image, myImage,myId,myName;
  final Timestamp date;

  const HomeModel({
    required this.date ,
    required this.image ,
    required this.myImage ,
    required this.myName ,
    required this.myId,
    required this.post
  });

  factory HomeModel.fromApp(Map<String,dynamic>map){
    return HomeModel(
        post: map['post'],
        date: map['date'] ,
        myId: map['myId'] ,
        image: map['image'],
        myName: map['myName'] ,
        myImage: map['myImage'] ,
    );
  }

  Map<String,dynamic> toApp()=>{
    'date' : date ,
    'post' : post ,
    'myId' : myId ,
    'image' : image ,
    'myName' : myName ,
    'myImage' : myImage ,
  };
}