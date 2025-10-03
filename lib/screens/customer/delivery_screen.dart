import 'package:flutter/material.dart';
import 'package:coffee_shop_app/widgets/custom_input.dart';
import 'package:coffee_shop_app/utils/validators.dart';

class DeliveryScreen extends StatefulWidget {
  const DeliveryScreen({super.key});

  @override
  State<DeliveryScreen> createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  String _deliveryOption = 'delivery';
  String? _selectedAddress;

  final List<String> _addresses = [
    '123 Main St, City',
    '456 Oak Ave, Town',
    '789 Pine Rd, Village'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery Options'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Choose Delivery Option',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              RadioListTile<String>(
                title: const Text('Delivery'),
                value: 'delivery',
                groupValue: _deliveryOption,
                onChanged: (value) {
                  setState(() {
                    _deliveryOption = value!;
                  });
                },
              ),
              RadioListTile<String>(
                title: const Text('Pickup'),
                value: 'pickup',
                groupValue: _deliveryOption,
                onChanged: (value) {
                  setState(() {
                    _deliveryOption = value!;
                  });
                },
              ),
              if (_deliveryOption == 'delivery') ...[
                const SizedBox(height: 20),
                const Text(
                  'Select Address',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _selectedAddress,
                  items: _addresses.map((address) {
                    return DropdownMenuItem(
                      value: address,
                      child: Text(address),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedAddress = value;
                    });
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  ),
                  validator: (value) {
                    if (_deliveryOption == 'delivery' && value == null) {
                      return 'Please select an address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  'Or Add New Address',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                CustomInput(
                  labelText: 'Enter new address',
                  controller: _addressController,
                  validator: (value) {
                    if (_deliveryOption == 'delivery' && 
                        _selectedAddress == null && 
                        (value == null || value.isEmpty)) {
                      return 'Please enter an address';
                    }
                    return null;
                  },
                ),
              ],
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      String address = _selectedAddress ?? _addressController.text;
                      Navigator.pop(context, {
                        'deliveryOption': _deliveryOption,
                        'address': _deliveryOption == 'delivery' ? address : null,
                      });
                    }
                  },
                  child: const Text('Continue'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}