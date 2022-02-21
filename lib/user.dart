class UserLoggedIn {
  static final UserLoggedIn _instance = UserLoggedIn._internal();

  // passes the instantiation to the _instance object
  factory UserLoggedIn() => _instance;

  //initialize variables in here
  UserLoggedIn._internal() {
    _userName = "e";
    _userEmail = "e";
    _userId = "e";
    _userGroup = "e";
    _userTeamColor = "e";
    _userFirstTimeRegister = "false";
  }
  String _userName="error";
  String _userEmail="error";
  String _userId="error";
  String _userGroup="error";
  String _userTeamColor="error";
  String _userFirstTimeRegister="false";

  //short getter for my variable
  String get userName => _userName;
  String get userEmail => _userEmail;
  String get userId => _userId;
  String get userGroup => _userGroup;
  String get userTeamColor => _userTeamColor;
  String get userFirstTimeRegister => _userFirstTimeRegister;

  //short setter for my variable
  set userName(String? value) => _userName = value!;
  set userEmail(String? value) => _userEmail = value!;
  set userId(String? value) => _userId = value!;
  set userGroup(String? value) => _userGroup = value!;
  set userTeamColor(String? value) => _userTeamColor = value!;
  set userFirstTimeRegister(String? value) => _userFirstTimeRegister = value!;
}