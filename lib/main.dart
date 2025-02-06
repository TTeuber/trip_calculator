import 'package:flutter/material.dart'; // Flutter library for creating UI components
import 'package:trip_calculator/calculator.dart'; // Custom module to perform trip cost calculations
import 'item.dart'; // Data model representing an individual trip item
import 'item_display.dart'; // Widget to display an individual trip item

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      home: ItemForm(),
    );
  }
}

class ItemForm extends StatefulWidget {
  const ItemForm({super.key});

  @override
  ItemFormState createState() => ItemFormState();
}

class ItemFormState extends State<ItemForm> { // Manages the state of the trip cost form

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _costController = TextEditingController();

  List<Item> items = []; // List to store all trip items

  @override void initState() {
    super.initState();
    items = [ // Pre-filled trip items for demonstration
      Item('Louis', 53.54, '1'),
      Item('Carter', 50.23, '2'),
      Item('David', 113.41, '3'),
    ];
    averageCost = items.map((item) => item.cost).reduce((a, b) => a + b) / items.length;
    totalCost = items.map((item) => item.cost).reduce((a, b) => a + b);
    results = calculator(items.map((item) => item.clone()).toList());
  }

  void onItemUpdated(Item updatedItem) { // Update an item in the list, Used in the ItemDisplay widget
    setState(() {
      final index = items.indexWhere((item) => item.id == updatedItem.id);
      if (index != -1) {
        items[index] = updatedItem.clone();
      }
      averageCost = items.map((item) => item.cost).reduce((a, b) => a + b) / items.length;
      totalCost = items.map((item) => item.cost).reduce((a, b) => a + b);
      results = calculator(items.map((item) => item.clone()).toList());
    });
  }

  List<String> results = []; // Stores the calculated results for display
  double averageCost = 0.0; // Average cost of all items
  double totalCost = 0.0; // Total cost of all items

  void _submitForm() {
    final String name = _nameController.text;
    final double? cost = double.tryParse(_costController.text);

    if (name.isNotEmpty && cost != null) {
      setState(() { // Add the new item and recalculate totals
        items.add(Item(name, cost, Item.generateID()));

        averageCost = items.map((item) => item.cost).reduce((a, b) => a + b) / items.length;
        totalCost = items.map((item) => item.cost).reduce((a, b) => a + b);
      });

      setState(() {
        results = calculator(items.map((item) => item.clone()).toList());
      });
    }

    _nameController.clear();
    _costController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold( // Main layout of the screen

      appBar: AppBar(title: Text('Trip Calculator', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold))), // App title bar

      body: SingleChildScrollView( // Scrollable content for smaller screens
        padding: EdgeInsets.all(16.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField( // Input for item name
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
              onSubmitted: (_) => _submitForm(),
            ),
            TextField( // Input for item cost
              controller: _costController,
              decoration: InputDecoration(labelText: 'Cost'),
              keyboardType: TextInputType.number,
              onSubmitted: (_) => _submitForm(),
            ),
            SizedBox(height: 10),
            ElevatedButton( // Submit button to add a new item
              onPressed: _submitForm,
              child: Text('Submit'),
            ),
            SizedBox(height: 20),
            if (results.isNotEmpty) ...[ // Display results only if they exist
              SizedBox(height: 20),
              Center(
                child: Text('Results', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)), // Results title
              ),
              ...results.map((result) => Center(child: Text(result, style: TextStyle(fontSize: 24)))),
            ],
            Row( // Display total and average costs
              children: [
                Text('Total Cost: \$${totalCost.toStringAsFixed(2)}', style: TextStyle(fontSize: 18)), // Show total cost
                SizedBox(width: 16),
                Text('Average Cost: \$${averageCost.toStringAsFixed(2)}', style: TextStyle(fontSize: 18)), // Show average cost
              ],
            ),
            ConstrainedBox(
              constraints: BoxConstraints(minHeight: 200.0, maxHeight: 500.0), // Constrain height for better presentation
              // height: 300.0, // Specify an explicit height for scrollable content
              child: SingleChildScrollView( // Scrollable list of items
                child: Column(
                  children: items.map((item) => ItemDisplay(item: item, onItemUpdated: onItemUpdated)).toList(),
                ),
              ),
            ),
          ]),
        ),
      );
  }
}

