class UserModel{
  String? id;
  String? name;
  String? email;
  String? password;
  int? age;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.password,
    this.age,
  });

  factory UserModel.fromJson(Map<String, dynamic> parsedJson) =>
      UserModel(
        name: parsedJson['name']?.toString(),
        email: parsedJson['email']?.toString(),
        password: parsedJson['password']?.toString(),
        age: int.parse(parsedJson['age']?.toString() ?? "0"),
      );

  List<UserModel> listFromJson(List<dynamic> list) {
    List<UserModel> rows =
    list.map((i) => UserModel.fromJson(i)).toList();
    return rows;
  }
}