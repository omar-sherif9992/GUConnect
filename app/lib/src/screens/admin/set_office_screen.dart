import 'dart:io';

import 'package:GUConnect/src/models/OfficeAndLocation.dart';
import 'package:GUConnect/src/providers/OfficeLocationProvider.dart';
import 'package:GUConnect/src/widgets/app_bar.dart';
import 'package:GUConnect/src/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SetOfficeAndLocationScreen extends StatefulWidget {
  final OfficeAndLocation? office;
  const SetOfficeAndLocationScreen({super.key, this.office});

  @override
  State<SetOfficeAndLocationScreen> createState() =>
      _SetOfficeAndLocationScreenState();
}

class _SetOfficeAndLocationScreenState
    extends State<SetOfficeAndLocationScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _officeController = TextEditingController();
  bool _isLoading = false;

 

  late OfficeLocationProvider officeProvider;

  String dropdownvalue = 'Office';

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.office != null) {
      _nameController.text = widget.office!.name;
      _officeController.text = widget.office!.location;
      dropdownvalue = widget.office!.isOffice ? 'Office' : 'Outlet';
      _latitudeController.text = widget.office!.latitude.toString();
      _longitudeController.text = widget.office!.longitude.toString();
    }

    officeProvider =
        Provider.of<OfficeLocationProvider>(context, listen: false);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _officeController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  Widget _buildForm() {
    return Form(
        key: _formKey,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              height: 500,
              child: Expanded(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      DropdownButton(
                        value: dropdownvalue,

                        icon: const Icon(Icons.keyboard_arrow_down),
                        iconSize: 24,
                        borderRadius: BorderRadius.circular(10),
                        alignment: Alignment.centerLeft,
                        hint: const Text('Select Office Type'),

                        items: ['Office', 'Outlet'].map((String items) {
                          return DropdownMenuItem(
                            value: items,
                            child: Text(items),
                          );
                        }).toList(),
                        // After selecting the desired option,it will
                        // change button value to selected value
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownvalue = newValue!;
                          });
                        },
                      ),
                      InputField(
                        controller: _nameController,
                        label: 'Name',
                        icon: Icons.person,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter name';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.name,
                      ),
                      InputField(
                        controller: _latitudeController,
                        label: 'Latitude',
                        icon: Icons.location_on,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a valid latitude ex: 23.456789';
                          }
                          if (!RegExp(r'^-?[0-9]{1,3}\.[0-9]{1,6}$')
                              .hasMatch(value)) {
                            return 'Please enter a valid latitude ex: 23.456789';
                          }

                          return null;
                        },
                      ),
                      InputField(
                        controller: _longitudeController,
                        label: 'Longitude',
                        icon: Icons.location_on,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a valid longitude ex: 23.456789';
                          }
                          if (!RegExp(r'^-?[0-9]{1,3}\.[0-9]{1,6}$')
                              .hasMatch(value)) {
                            return 'Please enter a valid longitude  ex: 23.456789';
                          }

                          return null;
                        },
                      ),
                      InputField(
                        controller: _officeController,
                        label: 'Office Location',
                        icon: Icons.location_on,
                        keyboardType: TextInputType.streetAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a valid office location ex: C7.201';
                          }
                          if (!RegExp(r'^[A-Z][0-9]\.[0-9]{3}$')
                              .hasMatch(value)) {
                            return 'Please enter a valid office location ex: C7.201';
                          }

                          return null;
                        },
                      ),
                      if (_isLoading)
                        const CircularProgressIndicator()
                      else
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final OfficeAndLocation officeAndLocation =
                                  OfficeAndLocation(
                                name: _nameController.text,
                                location: _officeController.text,
                                latitude:
                                    double.parse(_latitudeController.text),
                                longitude:
                                    double.parse(_longitudeController.text),
                                isOffice:
                                    dropdownvalue == 'Office' ? true : false,
                              );

                              setState(() {
                                _isLoading = true;
                              });

                              try {
                                await officeProvider.setOfficeAndLocation(
                                  officeAndLocation,
                                );
                                Navigator.of(context).pop();
                              } catch (e) {
                                print(e);
                                setState(() {
                                  _isLoading = false;
                                });
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            foregroundColor:
                                Theme.of(context).colorScheme.onSecondary,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            // size 30% of screen width
                            minimumSize: Size(
                                MediaQuery.of(context).size.width * 0.3, 50),
                            alignment: Alignment.center,
                          ),
                          child: const Text('Submit'),
                        )
                    ]),
              ),
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: CustomAppBar(
        title: widget.office == null ? 'Add Office/Outlet Location' : 'Edit Office/Outlet Location',
        isLogo: false,
        actions: [
          if (widget.office != null)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                final bool? confirm = await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Are you sure?'),
                    content: const Text(
                        'Do you want to delete this office permanently?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: const Text('No'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                        child: const Text('Yes'),
                      ),
                    ],
                  ),
                );

                if (widget.office != null && confirm == true) {
                  await officeProvider
                      .deleteOfficeAndLocation(widget.office!.name);

                  Navigator.of(context).pop({
                    'message': 'Office deleted successfully',
                    'success': true,
                    'office': widget.office,
                  });
                }
              },
            )
        ],
      ),
      body: _buildForm(),
    );
  }
}
