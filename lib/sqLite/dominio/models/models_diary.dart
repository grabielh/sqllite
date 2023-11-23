class MoDiary {
  int id;
  String type;
  String enterCode;

  MoDiary({required this.id, required this.type, required this.enterCode});
  @override
  String toString() {
    return 'id : $id  name : $type  password : $enterCode';
  }
}
