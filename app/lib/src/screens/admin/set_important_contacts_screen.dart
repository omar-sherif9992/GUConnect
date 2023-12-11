import 'package:GUConnect/src/models/ImportantEmail.dart';
import 'package:GUConnect/src/models/ImportantPhoneNumber.dart';
import 'package:GUConnect/src/models/Staff.dart';
import 'package:GUConnect/src/providers/ImportantEmailProvider.dart';
import 'package:GUConnect/src/providers/ImportantPhoneNumberProvider.dart';
import 'package:GUConnect/src/widgets/app_bar.dart';
import 'package:GUConnect/src/widgets/email_field.dart';
import 'package:GUConnect/src/widgets/input_field.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SetImportantContactsScreen extends StatefulWidget {
  final ImportantEmail? importantEmail;
  final ImportantPhoneNumber? importantPhoneNumber;
  const SetImportantContactsScreen(
      {super.key, this.importantEmail, this.importantPhoneNumber});

  @override
  State<SetImportantContactsScreen> createState() =>
      _SetImportantContactsScreenState();
}

class _SetImportantContactsScreenState
    extends State<SetImportantContactsScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  bool _isLoading = false;
  late ImportantEmailProvider importantEmailProvider;
  late ImportantPhoneNumberProvider importantPhoneNumberProvider;

  String dropdownvalue = 'Important Email';

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.importantEmail != null) {
      _titleController.text = widget.importantEmail!.title;
      _emailController.text = widget.importantEmail!.email;
      dropdownvalue = 'Important Email';
    } else if (widget.importantPhoneNumber != null) {
      _titleController.text = widget.importantPhoneNumber!.title;
      _phoneNumberController.text = widget.importantPhoneNumber!.phoneNumber;
      dropdownvalue = 'Important Phone Number';
    }
    importantEmailProvider =
        Provider.of<ImportantEmailProvider>(context, listen: false);
    importantPhoneNumberProvider =
        Provider.of<ImportantPhoneNumberProvider>(context, listen: false);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
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
                        hint: const Text('Select Contact Type'),

                        items: ['Important Email', 'Important Phone Number']
                            .map((String items) {
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
                        controller: _titleController,
                        label: 'Title',
                        icon: Icons.title,
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.length < 2) {
                            return 'Please enter a valid title';
                          }

                          return null;
                        },
                      ),
                      if (dropdownvalue == 'Important Email')
                        EmailField(
                          emailController: _emailController,
                        ),
                      if (dropdownvalue == 'Important Phone Number')
                        InputField(
                          controller: _phoneNumberController,
                          label: 'Phone Number',
                          icon: Icons.phone,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.length < 2) {
                              return 'Please enter a valid phone number';
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
                              final Staff staff = Staff(
                                fullName: _titleController.text,
                                email: _emailController.text,
                                officeLocation: _titleController.text,
                                staffType: dropdownvalue,
                              );

                              setState(() {
                                _isLoading = true;
                              });

                              try {
                                ScaffoldMessenger.of(context).clearSnackBars();
                                if (dropdownvalue == 'Important Email') {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Adding Important Email successfully'),
                                    ),
                                  );
                                  final importantEmail = ImportantEmail(
                                      title: _titleController.text,
                                      email: _emailController.text);
                                  await importantEmailProvider
                                      .addEmail(importantEmail);

                                  ScaffoldMessenger.of(context)
                                      .clearSnackBars();

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Added Important Email successfully'),
                                    ),
                                  );

                                  Navigator.of(context).pop('email');
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Adding Important Phone successfully'),
                                    ),
                                  );
                                  final importantPhoneNumber =
                                      ImportantPhoneNumber(
                                          title: _titleController.text,
                                          phoneNumber:
                                              _phoneNumberController.text);
                                  await importantPhoneNumberProvider
                                      .addNumber(importantPhoneNumber);
                                  ScaffoldMessenger.of(context)
                                      .clearSnackBars();

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Added Important Phone Number successfully'),
                                    ),
                                  );

                                  Navigator.of(context).pop('phone');
                                }
                              } catch (e) {
                                ScaffoldMessenger.of(context).clearSnackBars();

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Something went wrong. Please try again later'),
                                  ),
                                );
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
        title:
            widget.importantEmail == null && widget.importantPhoneNumber == null
                ? 'Add Contact'
                : 'Edit Contact',
        isLogo: false,
        actions: [
          if (widget.importantEmail != null &&
              widget.importantPhoneNumber != null)
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                final bool? confirm = await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Are you sure?'),
                    content: const Text(
                        'Do you want to delete this contact permanently?'),
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

                if (widget.importantEmail != null && confirm == true) {
                  await importantEmailProvider
                      .deleteEmail(widget.importantEmail!.title);

                  Navigator.of(context).pop({
                    'message': 'Important Email deleted successfully',
                    'success': true,
                    'staff': widget.importantEmail,
                  });
                } else if (widget.importantPhoneNumber != null &&
                    confirm == true) {
                  await importantPhoneNumberProvider
                      .deleteNumber(widget.importantPhoneNumber!.title);

                  Navigator.of(context).pop({
                    'message': 'Important Phone Number deleted successfully',
                    'success': true,
                    'staff': widget.importantPhoneNumber,
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
