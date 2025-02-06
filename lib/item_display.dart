import 'package:flutter/material.dart';
import 'item.dart';

class ItemDisplay extends StatefulWidget { // Widget to display and manage an Item

  final Item item; // The item to be displayed and edited
  final ValueChanged<Item> onItemUpdated; // Callback triggered when the item is updated

  const ItemDisplay({
    Key? key,
    required this.item,
    required this.onItemUpdated,
  }) : super(key: key);

  @override // Creates the state for the ItemDisplay widget
  _ItemDisplayState createState() => _ItemDisplayState();
}

class _ItemDisplayState extends State<ItemDisplay> { // State class to manage the text input and updates

  late TextEditingController _nameController;
  late TextEditingController _costController;

  @override
  void initState() { // Initializes the text controllers with existing item values
    super.initState();
    _nameController = TextEditingController(text: widget.item.name);
    _costController = TextEditingController(text: widget.item.cost.toStringAsFixed(2));
  }

  @override
  void dispose() { // Releases resources used by the text controllers
    _nameController.dispose();
    _costController.dispose();
    super.dispose();
  }

  void _onNameChanged(String newName) { // Updates the item's name and triggers the callback
    widget.onItemUpdated(
      Item(newName, widget.item.cost, widget.item.id),
    );
  }

  void _onCostChanged(String newCost) { // Updates the item's cost and triggers the callback
    final cost = double.tryParse(newCost) ?? widget.item.cost;
    widget.onItemUpdated(
      Item(widget.item.name, cost, widget.item.id),
    );
  }

  @override
  Widget build(BuildContext context) { // Builds the UI for the ItemDisplay widget

    return Card( // Displays a card containing the input fields
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField( // Input field for the item's name
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
              onChanged: _onNameChanged,
            ),
            const SizedBox(height: 16.0),
            TextField( // Input field for the item's cost
              controller: _costController,
              decoration: const InputDecoration(
                labelText: 'Cost',
              ),
              keyboardType: TextInputType.number, // Ensures the keyboard is optimized for numerical input
              onChanged: _onCostChanged,
            ),
          ],
        ),
      ),
    );
  }
}
