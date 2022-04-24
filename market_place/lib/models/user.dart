class User {
  String displayName;
  String email;
  String uid;
  DateTime accountCreated;
  List<String>? activeRequests = [];
  List<String>? completedRequests = [];
  int? totalRequests = 0;
  int? ordersPlaced = 0;

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

  factory User.createNew(String displayName, String email) {
    return User(
        uid: "unknown",
        displayName: displayName,
        accountCreated: DateTime.now(),
        email: email);
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

  Map toMap() {
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
