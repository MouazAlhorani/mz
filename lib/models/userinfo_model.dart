class UserInfoModel {
  final String username;
  final String fullname;
  final String password;
  final String email;
  final bool admin;
  final bool enable;
  final String ip;
  final bool loginstatus;
  final DateTime? lastlogin;
  UserInfoModel(
      {required this.username,
      required this.fullname,
      required this.password,
      required this.admin,
      required this.enable,
      required this.email,
      required this.ip,
      this.lastlogin,
      required this.loginstatus});
  factory UserInfoModel.fromdata({data}) {
    return UserInfoModel(
        username: data['username'],
        fullname: data['fullname'],
        password: data['password'],
        admin: data['admin'] == "1" ? true : false,
        enable: data['enable'] == "1" ? true : false,
        email: data['email'],
        ip: data['ip'],
        lastlogin: data['lastlogin'] != null
            ? DateTime.parse(data['lastlogin'])
            : null,
        loginstatus: data['loginstatus'] == "1" ? true : false);
  }
}
