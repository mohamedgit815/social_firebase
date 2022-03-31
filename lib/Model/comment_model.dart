class CommentModel {
  final String name , image , id , comment ;

  const CommentModel({
    required this.name ,
    required this.image ,
    required this.id ,
    required this.comment ,
  });

  factory CommentModel.fromApp(Map<String,dynamic>map){
    return CommentModel(
        name: map['name'] ,
        image: map['image'] ,
        id: map['id'] ,
        comment: map['comment'] ,
    );
  }
}