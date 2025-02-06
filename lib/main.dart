import 'package:flutter/material.dart';
import 'package:trip_calculator/calculator.dart';
import 'item.dart';
import 'item_display.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';

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

class ItemFormState extends State<ItemForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  List<Item> items = [];

  @override void initState() {
    super.initState();
    items = [
      Item('Louis', 53.54, '1'),
      Item('Carter', 50.23, '2'),
      Item('David', 113.41, '3'),
    ];
    averageCost = items.map((item) => item.cost).reduce((a, b) => a + b) / items.length;
    totalCost = items.map((item) => item.cost).reduce((a, b) => a + b);
    results = calculator(items.map((item) => item.clone()).toList());
  }

  void onItemUpdated(Item updatedItem) {
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
  List<String> results = [];
  double averageCost = 0.0;
  double totalCost = 0.0;

  Future<void> _submitForm() async {
    final String name = _nameController.text;
    final double? cost = double.tryParse(_costController.text);

    if (name.isNotEmpty && cost != null) {
      setState(() {
        items.add(Item(name, cost, Item.generateID()));

        averageCost = items.map((item) => item.cost).reduce((a, b) => a + b) / items.length;
        totalCost = items.map((item) => item.cost).reduce((a, b) => a + b);
      });

      // using the calculator function from the calculator.dart file
      setState(() {
        results = calculator(items.map((item) => item.clone()).toList());
      });

    // previously fetching data from flask server
    //   try {
    //     final response = await http.post(
    //       Uri.parse('http://127.0.0.1:5000'),
    //       headers: {'Content-Type': 'application/json'},
    //       body: jsonEncode(items),
    //     );
    //
    //     if (response.statusCode == 200) {
    //       setState(() {
    //         results = List<String>.from(jsonDecode(response.body));
    //       });
    //     } else {
    //       setState(() {
    //         results.add('Error: Invalid response');
    //       });
    //     }
    //   } catch (e) {
    //     setState(() {
    //       results.add('Error: Failed to connect');
    //     });
    //   }
    }

    _nameController.clear();
    _costController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Trip Calculator', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold))),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
              onSubmitted: (_) => _submitForm(),
            ),
            TextField(
              controller: _costController,
              decoration: InputDecoration(labelText: 'Cost'),
              keyboardType: TextInputType.number,
              onSubmitted: (_) => _submitForm(),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text('Submit'),
            ),
            SizedBox(height: 20),
            if (results.isNotEmpty) ...[
              SizedBox(height: 20),
              Center(
                child: Text('Results', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
              ),
              ...results.map((result) => Center(child: Text(result, style: TextStyle(fontSize: 24)))),
            ],
            Row(
              children: [
                Text('Total Cost: \$${totalCost.toStringAsFixed(2)}', style: TextStyle(fontSize: 18)),
                SizedBox(width: 16),
                Text('Average Cost: \$${averageCost.toStringAsFixed(2)}', style: TextStyle(fontSize: 18)),
              ],
            ),
            ConstrainedBox(
              constraints: BoxConstraints(minHeight: 200.0, maxHeight: 400.0),
              // height: 300.0, // Specify an explicit height for scrollable content
              child: SingleChildScrollView(
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

