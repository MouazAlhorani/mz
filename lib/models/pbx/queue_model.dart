class MQueue {
  final String queuename;
  final String number;
  final String agents;
  MQueue({required this.queuename, required this.number, required this.agents});
  factory MQueue.fromdata({data}) {
    return MQueue(
        queuename: data['queuename'],
        number: data['number'],
        agents: data['agents']);
  }
}
