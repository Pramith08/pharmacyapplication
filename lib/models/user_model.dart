class UserModel {
  final String name;
  final String email;
  final String mobileNumber;
  final String address;
  final String age;
  final String gender;
  final String dateOfBirth;
  final String userCreatedDateandTime;
  final String userId;

  UserModel({
    required this.name,
    required this.email,
    required this.mobileNumber,
    required this.address,
    required this.age,
    required this.gender,
    required this.dateOfBirth,
    required this.userCreatedDateandTime,
    required this.userId,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? "",
      email: map['email'] ?? "",
      mobileNumber: map['mobileNumber'] ?? "",
      address: map['address'] ?? "",
      age: map['age'] ?? "",
      gender: map['gender'] ?? "",
      dateOfBirth: map['dateOfBirth'] ?? "",
      userCreatedDateandTime: map['userCreatedDateandTime'] ?? "",
      userId: map['userId'] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "email": email,
      "mobileNumber": mobileNumber,
      "address": address,
      "age": age,
      "gender": gender,
      "dateOfBirth": dateOfBirth,
      "userId": userId,
      "userCreatedDateandTime": userCreatedDateandTime,
    };
  }
}
