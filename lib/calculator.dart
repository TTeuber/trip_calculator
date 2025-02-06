class Item {
   String name;
   double cost;

  Item(this.name, this.cost);

  // to deal with mutability issues
  Item clone() {
    return Item(name, cost);
  }
}

List<String> calculator(List<Item> items) {
  List<String> results = [];
  double averageCost =
      items.map((i) => i.cost).reduce((a, b) => a + b) / items.length;

  List<Item> aboveAverage =
    items.where((i) => i.cost > averageCost).toList();

  List<Item> belowAverage =
    items.where((i) => i.cost < averageCost).toList();

  for (var item in belowAverage) {
    double transferFrom = double.parse((averageCost - item.cost).toStringAsFixed(2));
    item.cost = item.cost + transferFrom;

    double aboveCostSum =
      aboveAverage.fold(0, (sum, p) => sum + (p.cost - averageCost));

    for (var i in aboveAverage) {
      double transferTo = double.parse(
          (((i.cost - averageCost) / aboveCostSum) * transferFrom).toStringAsFixed(2)
      );
      results.add("${item.name} transfers \$${transferTo.toStringAsFixed(2)} to ${i.name}");
      i.cost = i.cost - transferTo;
    }
  }

  return results;
}