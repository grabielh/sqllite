class MoDiary {
  int id;
  String userName;
  String enterCode;

  MoDiary({required this.id, required this.userName, required this.enterCode});
  @override
  String toString() {
    return 'id : $id  name : $userName  password : $enterCode';
  }
}
