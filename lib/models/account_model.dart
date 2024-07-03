class AccountsModel {
  final int id;
  String? username, password, email, fullname, admin, ip;
  bool enable, loginstatus;
  DateTime? lastlogin;
  bool search;

  AccountsModel(
      {required this.id,
      this.enable = true,
      this.username,
      this.admin,
      this.email,
      this.fullname,
      this.password,
      this.ip,
      this.lastlogin,
      this.loginstatus = false,
      this.search = true});
  factory AccountsModel.fromdata({data}) {
    return AccountsModel(
        id: data['id'],
        username: data['username'],
        password: data['password'],
        fullname: data['fullname'],
        email: data['email'],
        admin: data['admin'],
        enable: data['enable'] ? true : false,
        ip: data['ip'],
        loginstatus: data['loginstatus'],
        lastlogin: data['lastlogin'] == null
            ? null
            : DateTime.parse(data['lastlogin']),
        search: true);
  }
}
