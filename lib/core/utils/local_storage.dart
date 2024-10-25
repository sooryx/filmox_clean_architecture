import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  SharedPreferencesManager._privateConstructor();

  static final SharedPreferencesManager _instance =
  SharedPreferencesManager._privateConstructor();

  factory SharedPreferencesManager() => _instance;

  static const String _accessTokenKey = 'access_token';
  static const String _userID = '_userID';
  static const String _userPic = '_userPic';
  static const String _userType = '_userType';
  static const String _phoneNumber = '_phoneNumber';
  static const String _name = '_name';
  static const String _singleID = '_singleID';
  static const String _multipleID = '_multipleID';
  static const String _uploadType = '_uploaType';

  SharedPreferences? _preferences;

  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  Future<void> setLoggedIn(bool isLoggedIn) async {
    await _preferences?.setBool('isLoggedIn', isLoggedIn);
    print('Login state set: $isLoggedIn');
  }

  Future<void> setAccessToken(String accessToken) async {
    print("Auth token has been saved :$accessToken");
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, accessToken);
  }

  Future<void> setUserID(String userID) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userID, userID);
  }

  Future<void> setUserPic(String userPic) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userPic, userPic);
  }

  Future<void> setUsername(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_name, name);
  }

  Future<void> setPhone(String phoneNumber) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_phoneNumber, phoneNumber);
  }

  Future<void> setSingleFileID(String id) async {
    final prefs = await SharedPreferences.getInstance();
    print("Single ID : $id");
    await prefs.setString(_singleID, id);
  }

  Future<void> setMultipleFileID(String id) async {
    final prefs = await SharedPreferences.getInstance();
    print("Multiple ID : $id");
    await prefs.setString(_multipleID, id);
  }

  Future<void> setUploadType(String uploadType) async {
    final prefs = await SharedPreferences.getInstance();
    print("uploadType : $uploadType");
    await prefs.setString(_uploadType, uploadType);
  }

  Future<void> setUserType(String userType) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userType, userType);
  }

  Future<String?> getUserPhoto() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userPic);
  }

  Future<String?> getUserType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userType);
  }

  Future<String?> getUserID() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userID);
  }

  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_name);
  }

  Future<String?> getPhoneNo() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_phoneNumber);
  }

  Future<String?> getSingleDTID() async {
    return _preferences?.getString(_singleID);
  }

  Future<String?> getMultipleDTID() async {
    return _preferences?.getString(_multipleID);
  }

  bool? get isLoggedIn {
    return _preferences?.getBool('isLoggedIn') ?? false;
  }

  Future<void> logout() async {
    await _preferences?.clear();
  }

  Future<void> clearFileIDs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_singleID);
    await prefs.remove(_multipleID);
    print("Single and Multiple File IDs cleared");
  }
}
