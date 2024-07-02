class CallsInWaitting {
  final List memebers;
  final String from;
  final String type;
  String? trunkname;
  String memberstatus;
  CallsInWaitting(
      {required this.memebers,
      required this.from,
      this.trunkname,
      required this.type,
      required this.memberstatus});
  factory CallsInWaitting.fromdata({data}) {
    if (data['members'][0].keys.first == "inbound") {
      return CallsInWaitting(
          type: "inbound",
          memebers: data['members'],
          from: data['members'][0]['inbound']['from'],
          trunkname: data['members'][0]['inbound']['trunkname'],
          memberstatus: data['members'][0]['inbound']['memberstatus']);
    } else {
      return CallsInWaitting(
          type: "outbound", memebers: [], from: "", memberstatus: "");
    }
  }
}
