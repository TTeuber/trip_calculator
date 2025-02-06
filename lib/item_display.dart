import 'package:flutter/material.dart';
import 'item.dart';

class ItemDisplay extends StatefulWidget {
  final Item item;
  final ValueChanged<Item> onItemUpdated;

  const ItemDisplay({
    Key? key,
    required this.item,
    required this.onItemUpdated,
  }) : super(key: key);

  @override
  _ItemDisplayState createState() => _ItemDisplayState();
}

class _ItemDisplayState extends State<ItemDisplay> {
  late TextEditingController _nameController;
  late TextEditingController _costController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item.name);
    _costController = TextEditingController(text: widget.item.cost.toStringAsFixed(2));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _costController.dispose();
    super.dispose();
  }

  void _onNameChanged(String newName) {
    widget.onItemUpdated(
      Item(newName, widget.item.cost, widget.item.id),
    );
  }

  void _onCostChanged(String newCost) {
    final cost = double.tryParse(newCost) ?? widget.item.cost;
    widget.onItemUpdated(
      Item(widget.item.name, cost, widget.item.id),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
              onChanged: _onNameChanged,
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _costController,
              decoration: const InputDecoration(
                labelText: 'Cost',
              ),
              keyboardType: TextInputType.number,
              onChanged: _onCostChanged,
            ),
          ],
        ),
      ),
    );
  }
}
