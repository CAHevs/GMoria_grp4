class ListObject {
  String name;
  String id;
  List<String> users;

  ListObject(this.id, this.name, this.users);


  String getName() {
    return name;
  }

  String getId() {
    return id;
  }

  List<String> getUsers() {
    return users;
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
