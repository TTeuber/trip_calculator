import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:trip_calculator/calculator.dart';

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
  List<String> results = [];
  double averageCost = 0.0;

  Future<void> _submitForm() async {
    final String name = _nameController.text;
    final double? cost = double.tryParse(_costController.text);

    if (name.isNotEmpty && cost != null) {
      setState(() {
        items.add(Item(name, cost));

        averageCost = items.map((item) => item.cost).reduce((a, b) => a + b) / items.length;
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
      appBar: AppBar(title: Text('Item Form')),
      body: Padding(
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
            Text('Average Cost: \$${averageCost.toStringAsFixed(2)}'),
            ...items.map((item) => Text("${item.name} - ${item.cost}")),
            if (results.isNotEmpty) ...[
              SizedBox(height: 20),
              Text('Results', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ...results.map((result) => Text(result)),
            ]
          ],
        ),
      ),
    );
  }
}

