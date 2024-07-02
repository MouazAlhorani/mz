class Extension {
  final String? number;
  final String? name;
  final String? status;
  final String? type;
  final String? from, to;
  final String? trunkname;
  Extension(
      {this.number,
      this.name,
      this.status,
      this.from,
      this.to,
      this.trunkname,
      this.type});
  factory Extension.getExtsListfromdata({data}) {
    return Extension(
      number: data['number'],
      name: data['username'],
      status: data['status'],
    );
  }

  factory Extension.fromdataAsCallqueue({data, required List<Extension> exts}) {
    if (data['numbercalls'][0]['members'][0].keys.first == "inbound") {
      return Extension(
        name: exts
            .where((element) => element.number == data['number'])
            .first
            .name,
        type: "inbound",
        number: data['number'],
        from: data['numbercalls'][0]['members'][0]['inbound']['from'],
        trunkname: data['numbercalls'][0]['members'][0]['inbound']['trunkname'],
        status: data['numbercalls'][0]['members'][0]['inbound']['memberstatus'],
      );
    } else {
      return Extension(
        name: exts
            .where((element) => element.number == data['number'])
            .first
            .name,
        type: "other",
        number: data['number'],
        to: data['numbercalls'][0]['members'][1]['outbound']['to'],
        trunkname: data['numbercalls'][0]['members'][1]['outbound']
            ['trunkname'],
        status: data['numbercalls'][0]['members'][1]['outbound']
            ['memberstatus'],
      );
    }
  }
}
