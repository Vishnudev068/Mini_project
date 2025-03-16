double? globalLatitude;
double? globalLongitude;

class GlobalState {
  static final GlobalState _instance = GlobalState._internal();

  String? userId; // Variable to store User ID

  factory GlobalState() {
    return _instance;
  }

  GlobalState._internal();

  void setUserId(String id) {
    userId = id;
  }

  String? getUserId() {
    return userId;
  }
}
