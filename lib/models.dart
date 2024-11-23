

class messageModel{
  final String title;
  final String body;
  messageModel({
    required this.body,
    required this.title,
  });
  Map<String,dynamic> toJyson()=>{
    "title":title,
    "body":body,
  };

}