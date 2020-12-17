class Users {
  String id;
  String firstname;
  String lastname;
  String image;

  Users(this.id, this.firstname, this.lastname, this.image);

  String getId() {
    return id;
  }

  String getFirstname() {
    return firstname;
  }

  String getLastname() {
    return lastname;
  }

  String getImage() {
    return image;
  }

  void setId(String id) {
    this.id = id;
  }

  void setFirstname(String firstname) {
    this.firstname = firstname;
  }

  void setLastname(String lastname) {
    this.lastname = lastname;
  }

  void setImage(String image) {
    this.image = image;
  }
}
