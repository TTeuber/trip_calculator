class Item {
  String name;
  double cost;
  String id;

  Item(this.name, this.cost, this.id);

  Item clone() { // Creates a duplicate of the item, used to avoid mutability issues
    return Item(name, cost, id);
  }
  static String generateID() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  void show() { // Displays the item's details, used for debugging
    print('Name: $name, Cost: $cost, ID: $id');
  }
}
