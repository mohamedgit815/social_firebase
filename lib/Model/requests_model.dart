import 'package:cloud_firestore/cloud_firestore.dart';

class RequestsModel {
  final String first , last , email , image , id , bio ;
  final Timestamp date;

  const RequestsModel({
    required this.bio , required this.first , required this.last ,
    required this.email, required this.image, required this.id ,
   required this.date
  });

  factory RequestsModel.fromApp(Map<String,dynamic>map){
    return RequestsModel(
        first: map['first'],
        last: map['last'],
        email: map['email'] ,
        image: map['image'],
        id: map['id'] ,
        bio: map['bio'] ,
        date: map['date']
    );
  }

  Map<String,dynamic> toApp() => {
    'first' : first ,
    'last' : last ,
    'email' : email ,
    'image' : image ,
    'id' : id ,
    'bio': bio ,
    'date' : date
  };
}