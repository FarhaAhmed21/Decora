class UserModel {
  final String name;
  final String email;
  final String phoneNum;
  final String location;
  final String photoLink;
  final String uid;

  UserModel({
    required this.name,
    required this.email,
    required this.phoneNum,
    required this.location,
    required this.photoLink,
    required this.uid,
  });

  /// 🔹 تحويل بيانات من Firebase إلى UserModel
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phoneNum: map['phone_num'] ?? '',
      location: map['location'] ?? '',
      photoLink: map['photo_link'] ?? '',
      uid: map['uid'] ?? '',
    );
  }

  /// 🔹 تحويل UserModel إلى Map علشان نخزّنه في Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone_num': phoneNum,
      'location': location,
      'photo_link': photoLink,
      'uid': uid,
    };
  }
}
