class ServiceProvider {
  String uid;
  String displayName;
  List? services = [];
  int? ordersCompleted = 0;
  double? averageRating = 0;
  int? ratings = 0;
  List? reviews = [];
  String? description = '';
  DateTime accountCreated;
  String email;

  static const String type = "service-provider";

  ServiceProvider(
      {required this.uid,
      required this.displayName,
      required this.email,
      required this.accountCreated,
      this.description,
      this.services,
      this.ordersCompleted,
      this.averageRating,
      this.ratings,
      this.reviews});

  factory ServiceProvider.fromMap(Map map) {
    Map nullMap = {
      "services": [],
      "ordersCompleted": 0,
      "averageRating": 0,
      "ratings": 0,
      "reviews": [],
      "description": '',
    };

    nullMap.forEach(
      (key, value) {
        map.putIfAbsent(key, () => value);
      },
    );

    return ServiceProvider(
        uid: map["uid"],
        displayName: map["displayName"],
        email: map["email"],
        accountCreated: DateTime.parse(map["accountCreated"]),
        description: map["description"],
        reviews: map["reviews"],
        averageRating: map["averageRating"],
        ordersCompleted: map["ordersCompleted"],
        ratings: map["ratings"],
        services: map["services"]);
  }

  factory ServiceProvider.createNew(
      String uid, String email, String displayName) {
    return ServiceProvider(
      uid: uid,
      displayName: displayName,
      email: email,
      accountCreated: DateTime.now(),
      averageRating: 0,
      description: '',
      ordersCompleted: 0,
      ratings: 0,
      reviews: [],
      services: [],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "displayName": displayName,
      "services": services,
      "ordersCompleted": ordersCompleted,
      "averageRating": averageRating,
      "ratings": ratings,
      "accountCreated": accountCreated.toString(),
      "email": email,
      "description": description,
    };
  }
}
