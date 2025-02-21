import 'item.dart';

/// Calculates the cost redistribution process to equalize costs among items.
///
/// Accepts a list of `Item` objects, performs calculations to redistribute
/// costs between items below the average cost to those above it.
///
/// Input:
/// - `items`: A list of `Item` objects, where each item has a name and cost.
///
/// Output:
/// - Returns a list of strings describing the cost transfer transactions between items.
///
List<String> calculator(List<Item> items) {
  List<String> results = [];

  double averageCost =
      items.map((i) => i.cost).reduce((a, b) => a + b) / items.length;

  List<Item> aboveAverage =
    items.where((i) => i.cost > averageCost).toList();

  List<Item> belowAverage =
    items.where((i) => i.cost < averageCost).toList();

  // For each item below average, calculate the needed transfer amount and adjust costs.
  for (var item in belowAverage) {

    // The amount to be transferred to the item currently below average.
    double transferFrom = double.parse((averageCost - item.cost).toStringAsFixed(2));
    // item.cost = item.cost + transferFrom;

    double aboveCostSum =
      aboveAverage.fold(0, (sum, p) => sum + (p.cost - averageCost));

    // Distribute the calculated transfer amounts to items above average proportionally.
    for (var i in aboveAverage) {

      // The amount to transfer from this below-average item to the current above-average item.
      double transferTo = double.parse(
          (((i.cost - averageCost) / aboveCostSum) * transferFrom).toStringAsFixed(2)
      );

      results.add("${item.name} transfers \$${transferTo.toStringAsFixed(2)} to ${i.name}");
      // i.cost = i.cost - transferTo;
    }
  }

  // Return the list of transaction descriptions detailing the redistribution process.
  return results.toList();
}