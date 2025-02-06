List<String> calculator(List<Map<String, dynamic>> people) {
  List<String> results = [];
  double averageCost =
      people.map((p) => p["cost"] as double).reduce((a, b) => a + b) / people.length;

  List<Map<String, dynamic>> aboveAverage =
    people.where((p) => (p["cost"] as double) > averageCost).toList();

  List<Map<String, dynamic>> belowAverage =
    people.where((p) => (p["cost"] as double) < averageCost).toList();

  for (var person in belowAverage) {
    double transfer = double.parse((averageCost - (person["cost"] as double)).toStringAsFixed(2));
    person["cost"] = (person["cost"] as double) + transfer;

    double aboveCostSum =
      aboveAverage.fold(0, (sum, p) => sum + ((p["cost"] as double) - averageCost));

    for (var p in aboveAverage) {
      double pTransfer = double.parse(
          ((((p["cost"] as double) - averageCost) / aboveCostSum) * transfer).toStringAsFixed(2)
      );
      results.add("${person["name"]} transfers \$${pTransfer.toStringAsFixed(2)} to ${p["name"]}");
      p["cost"] = (p["cost"] as double) - pTransfer;
    }
  }

  return results;
}