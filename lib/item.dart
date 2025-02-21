class Item {
  String name;
  List<double> individualCosts = [];
  String id;

  // Dynamically calculate cost as the sum of individualCosts
  double get cost => individualCosts.fold(0, (a, b) => a + b);

  Item(this.name, this.id, individualCosts) {
    if (individualCosts != []) {
      this.individualCosts = individualCosts;
    } else {
      this.individualCosts.add(0); // Default a single cost of 0 if no initial costs are provided
    }
  }


  Item clone() {
    return Item(name, id, individualCosts);
  }

  static String generateID() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  void show() { // Displays the item's details, used for debugging
    print('Name: $name, Cost: $cost, ID: $id, Individual Costs: $individualCosts');
  }
}
