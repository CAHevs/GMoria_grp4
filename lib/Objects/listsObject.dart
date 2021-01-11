//A class for get all the lists
class ListObject {
  String name;
  String id;
  List<String> users;
  int score;

  ListObject(this.id, this.name, this.score);

  String getName() {
    return name;
  }

  String getId() {
    return id;
  }

  List<String> getUsers() {
    return users;
  }

  int getScore(){
    return score;
  }

  void setScore(int score){
    this.score = score;
  }

  void setName(String name) {
    this.name = name;
  }

  void setId(String id) {
    this.id = id;
  }

  void setUsers(List<String> users) {
    this.users = users;
  }
}
