class Users {
  String id;
  String firstname;
  String lastname;
  String image;
  String note;

  Users(this.id, this.firstname, this.lastname, this.image, this.note);

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

  String getNote(){
    return note;
  }

  void setNote(String note){
    this.note = note;
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
