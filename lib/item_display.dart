import 'package:flutter/material.dart';
import 'item.dart';

class ItemDisplay extends StatefulWidget {
  final Item item;
  final ValueChanged<Item> onItemUpdated;

  const ItemDisplay({
    super.key,
    required this.item,
    required this.onItemUpdated,
  });

  @override
  _ItemDisplayState createState() => _ItemDisplayState();
}

class _ItemDisplayState extends State<ItemDisplay> {
  late TextEditingController _nameController;
  late List<TextEditingController> _individualCostControllers;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item.name);

    // Initialize controllers for individualCosts
    _individualCostControllers = widget.item.individualCosts
        .map((cost) => TextEditingController(text: cost.toStringAsFixed(2)))
        .toList();
  }

  @override
  void dispose() {
    _nameController.dispose();
    for (var controller in _individualCostControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onNameChanged(String newName) {
    widget.onItemUpdated(
      Item(newName, widget.item.id, widget.item.individualCosts),
    );
  }

  void _onIndividualCostChanged(int index, String newCost) {
    final costs = widget.item.individualCosts;
    final updatedCosts = List<double>.from(costs);

    // Parse the updated cost or default to the previous value
    updatedCosts[index] = double.tryParse(newCost) ?? costs[index];

    // Trigger the update with the new individualCosts
    widget.onItemUpdated(
      Item(
        widget.item.name,
        widget.item.id,
        updatedCosts,
      ),
    );
  }

  void _addIndividualCost() {
    final updatedCosts = [...widget.item.individualCosts, 0.0];

    // Update the parent with the new individualCosts and reload controllers
    widget.onItemUpdated(
      Item(widget.item.name, widget.item.id, updatedCosts),
    );

    setState(() {
      _individualCostControllers.add(TextEditingController(text: "0.00"));
    });
  }

  void _removeIndividualCost(int index) {
    if (widget.item.individualCosts.length <= 1) return; // Ensure at least one cost remains
    final List<double> updatedCosts = List.from(widget.item.individualCosts)..removeAt(index);

    widget.onItemUpdated(
      Item(widget.item.name, widget.item.id, updatedCosts),
    );

    setState(() {
      _individualCostControllers.removeAt(index);
    });
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
              decoration: const InputDecoration(labelText: 'Name'),
              onChanged: _onNameChanged,
            ),
            const SizedBox(height: 16.0),
            Text(
              'Individual Costs:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ...List.generate(widget.item.individualCosts.length, (index) {
              return Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _individualCostControllers[index],
                      decoration: const InputDecoration(
                        labelText: 'Cost',
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) => _onIndividualCostChanged(index, value),
                    ),
                  ),
                  IconButton(
                    onPressed: () => _removeIndividualCost(index),
                    icon: const Icon(Icons.remove_circle, color: Colors.red),
                  ),
                ],
              );
            }),
            const SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: _addIndividualCost,
              child: const Text('Add Individual Cost'),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Total Cost: \$${widget.item.cost.toStringAsFixed(2)}',
              // style: Theme.of(context).textTheme.subtitle1,
            ),
          ],
        ),
      ),
    );
  }
}