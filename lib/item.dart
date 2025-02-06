/// Represents an item with a name and a cost.
/// Provides a method to create a duplicate of the item to handle mutability issues.
class Item {
  String name;
  double cost;
  String id;

  Item(this.name, this.cost, this.id);

  Item clone() {
    return Item(name, cost, id);
  }
  static String generateID() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  void show() {
    print('Name: $name, Cost: $cost, ID: $id');
  }
}
