import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(DieselEntryApp());
}

class DieselEntryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Diesel Entry Form',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: DieselEntryScreen(),
    );
  }
}

class DieselEntryScreen extends StatefulWidget {
  @override
  _DieselEntryScreenState createState() => _DieselEntryScreenState();
}

class _DieselEntryScreenState extends State<DieselEntryScreen> {
  final TextEditingController _vehicleController = TextEditingController();
  final TextEditingController _driverController = TextEditingController();
  final TextEditingController _dieselAmountController = TextEditingController();
  final TextEditingController _pumpNameController = TextEditingController();
  DateTime? _selectedDate;
  
  List<Map<String, String>> entries = [];

  final List<String> vehicleNumbers = ["ABC-1234", "XYZ-5678", "LMN-9101"];
  final List<String> driverNames = ["John Doe", "Jane Smith", "Michael Brown"];

  void _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _addEntry() {
    if (_vehicleController.text.isEmpty ||
        _driverController.text.isEmpty ||
        _selectedDate == null ||
        _dieselAmountController.text.isEmpty ||
        _pumpNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    setState(() {
      entries.add({
        "vehicle": _vehicleController.text,
        "driver": _driverController.text,
        "date": DateFormat('yyyy-MM-dd').format(_selectedDate!),
        "diesel": _dieselAmountController.text,
        "pump": _pumpNameController.text,
      });
      _vehicleController.clear();
      _driverController.clear();
      _dieselAmountController.clear();
      _pumpNameController.clear();
      _selectedDate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Diesel Entry Form')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSearchableDropdown("Vehicle Number", _vehicleController, vehicleNumbers),
            SizedBox(height: 10),
            _buildSearchableDropdown("Driver Name", _driverController, driverNames),
            SizedBox(height: 10),
            _buildDatePicker(context),
            SizedBox(height: 10),
            _buildTextField("Diesel Amount (Ltr)", _dieselAmountController, TextInputType.number),
            SizedBox(height: 10),
            _buildTextField("Pump Name", _pumpNameController, TextInputType.text),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: _addEntry, child: Text("Confirm")),
                ElevatedButton(onPressed: () {}, child: Text("Submit")),
              ],
            ),
            SizedBox(height: 20),
            Text("Diesel Entry List", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: entries.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Text("Vehicle: ${entries[index]['vehicle']}"),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Driver: ${entries[index]['driver']}"),
                          Text("Date: ${entries[index]['date']}"),
                          Text("Diesel: ${entries[index]['diesel']} Ltr"),
                          Text("Pump: ${entries[index]['pump']}"),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, TextInputType keyboardType) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildSearchableDropdown(String label, TextEditingController controller, List<String> suggestions) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        return suggestions.where((option) => option.toLowerCase().contains(textEditingValue.text.toLowerCase()));
      },
      onSelected: (String selection) {
        controller.text = selection;
      },
      fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
        return TextField(
          controller: textEditingController,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(),
          ),
        );
      },
    );
  }

  Widget _buildDatePicker(BuildContext context) {
    return InkWell(
      onTap: () => _selectDate(context),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: "Select Date",
          border: OutlineInputBorder(),
        ),
        child: Text(
          _selectedDate == null ? "Choose a Date" : DateFormat('yyyy-MM-dd').format(_selectedDate!),
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
