class Person {
  late int id;
  late String name;
  late String age;
  late String img;
  Person(
      {required this.id,
      required this.name,
      required this.age,
      required this.img});
  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'age': age, 'img': img};
  }

  Person.fromMap(Map<String, dynamic> res)
      : id = res["id"],
        name = res["name"],
        age = res["age"],
        img = res["img"];
}
