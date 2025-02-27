import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(VehicleMaintenanceApp());
}

class VehicleMaintenanceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Vehicle Maintenance Form',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: VehicleMaintenanceScreen(),
    );
  }
}

class VehicleMaintenanceScreen extends StatefulWidget {
  @override
  _VehicleMaintenanceScreenState createState() => _VehicleMaintenanceScreenState();
}

class _VehicleMaintenanceScreenState extends State<VehicleMaintenanceScreen> {
  final TextEditingController _transactionNumberController =
      TextEditingController(text: "System Generate");
  final TextEditingController _vehicleController = TextEditingController();
  final TextEditingController _maintenanceDateController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _workshopNameController = TextEditingController();
  final TextEditingController _costController = TextEditingController();

  DateTime? _selectedDate;
  String? selectedVehicle;
  String? selectedMaintenanceType;
  String? selectedWorkshopType;

  List<Map<String, String>> records = [];

  final List<String> vehicleNumbers = ["ABC-1234", "XYZ-5678", "LMN-9101"];
  final List<String> maintenanceTypes = [
    "Oil Change",
    "Tire Replacement",
    "Battery Replacement",
    "Brake Service",
    "Other"
  ];
  final List<String> workshopTypes = ["InHouse Workshop", "3rd Party Workshop"];

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
        _maintenanceDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _addRecord() {
    if (selectedMaintenanceType == null ||
        selectedWorkshopType == null ||
        _costController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all task details")),
      );
      return;
    }

    setState(() {
      records.add({
        "maintenanceType": selectedMaintenanceType!,
        "workshopType": selectedWorkshopType!,
        "cost": _costController.text,
      });
    });

    Navigator.pop(context);
    _costController.clear();
    _workshopNameController.clear();
    selectedMaintenanceType = null;
    selectedWorkshopType = null;
  }

  void _openTaskTypeForm() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Enter Task Details"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDropdown("Maintenance Type", maintenanceTypes, (value) {
                setState(() => selectedMaintenanceType = value);
              }),
              SizedBox(height: 10),
              _buildDropdown("Workshop Type", workshopTypes, (value) {
                setState(() => selectedWorkshopType = value);
              }),
              SizedBox(height: 10),
              _buildTextField("Workshop Name", _workshopNameController, TextInputType.text),
              SizedBox(height: 10),
              _buildTextField("Cost", _costController, TextInputType.number),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
            ElevatedButton(onPressed: _addRecord, child: Text("Save")),
          ],
        );
      },
    );
  }

  Widget _buildDropdown(String label, List<String> items, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
      value: items.contains(selectedMaintenanceType) ? selectedMaintenanceType : null,
      onChanged: onChanged,
      items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Vehicle Maintenance Form')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTextField("Transaction Number", _transactionNumberController, TextInputType.text),
            SizedBox(height: 10),
            _buildDropdown("Vehicle Number", vehicleNumbers, (value) {
              setState(() => selectedVehicle = value);
            }),
            SizedBox(height: 10),
            TextField(
              controller: _maintenanceDateController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: "Date",
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
              ),
            ),
            SizedBox(height: 10),
            _buildTextField("Additional Notes", _notesController, TextInputType.text),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: () {}, child: Text("Submit")),
                ElevatedButton(onPressed: _openTaskTypeForm, child: Text("TaskType")),
                ElevatedButton(onPressed: () {}, child: Text("Confirm")),
              ],
            ),
            SizedBox(height: 20),
            Text("Maintenance Records", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: records.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Text("Maintenance: ${records[index]['maintenanceType']}"),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Workshop: ${records[index]['workshopType']}"),
                          Text("Cost: \$${records[index]['cost']}"),
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
}
