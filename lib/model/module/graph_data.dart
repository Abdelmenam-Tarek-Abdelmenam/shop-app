class GraphData {
  List<int> money;
  List<int> orders;

  GraphData({required this.money, required this.orders});

  factory GraphData.empty() => GraphData(money: [], orders: []);

  bool get isEmpty => money.isEmpty && orders.isEmpty;
}
