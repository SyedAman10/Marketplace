class User {
  String displayName;
  String email;
  String uid;
  DateTime accountCreated;
  List? activeRequests = [];
  List? completedRequests = [];
  int? totalRequests = 0;
  int? ordersPlaced = 0;

  static const String type = "user";

  User({
    required this.uid,
    required this.displayName,
    required this.accountCreated,
    required this.email,
    this.activeRequests,
    this.completedRequests,
    this.ordersPlaced,
    this.totalRequests,
  });

  factory User.createNew(String uid, String email, String displayName) {
    return User(
      uid: uid,
      displayName: displayName,
      accountCreated: DateTime.now(),
      email: email,
      activeRequests: [],
      completedRequests: [],
      ordersPlaced: 0,
      totalRequests: 0,
    );
  }

  factory User.fromMap(Map map) {
    Map nullMap = {
      "activeRequests": [],
      "completedRequests": [],
      "ordersPlaced": 0,
      "totalRequests": 0
    };

    nullMap.forEach(
      (key, value) {
        map.putIfAbsent(key, () => value);
      },
    );

    return User(
      accountCreated: DateTime.parse(map["accountCreated"]),
      displayName: map["displayName"],
      email: map["email"],
      uid: map["uid"],
      activeRequests: map["activeRequests"],
      completedRequests: map["completedRequests"],
      ordersPlaced: map["ordersPlaced"],
      totalRequests: map["totalRequests"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "displayName": displayName,
      "accountCreated": accountCreated.toString(),
      "email": email,
      "activeRequests": activeRequests,
      "completedRequests": completedRequests,
      "ordersPlaced": ordersPlaced,
      "totalRequests": totalRequests,
    };
  }
}
